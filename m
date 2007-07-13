Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbXGMRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbXGMRfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbXGMRfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:35:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbXGMRfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:35:34 -0400
Message-ID: <4697B7DB.3030006@zytor.com>
Date: Fri, 13 Jul 2007 10:35:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>
CC: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Please revert 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It causes build failures on i386.

Yet another case of unnecessary divergence between i386 and x86-64 I'm
afraid...

	-hpa
