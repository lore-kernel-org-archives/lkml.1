Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZJBNo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZJBNo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZJBNo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:44:28 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:18783 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbZJBNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:44:28 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC6025B.4000008@tremplin-utc.net>
Date: Fri, 02 Oct 2009 15:38:35 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Additional hardware support for lis3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,
Here are 3 patches to better support the various HP laptops with the
lis3lv03d driver. They are against 2.6.32-rc1, and hopefully it's not
too late for 2.6.32 as they are rather trivial :-)

See you,
Eric

