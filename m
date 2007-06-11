Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXFKXwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXFKXwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXFKXwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:52:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbXFKXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:52:46 -0400
Message-ID: <466DE04C.4020303@zytor.com>
Date: Mon, 11 Jun 2007 16:52:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Can we get rid of zImage this time?
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I brought this up a few years ago, and had it shot down, because of a
few poorly substantiated claims of zImage-only machines; those claims
really need to be debugged since they might indicate A20-related failures.

Anyway...

Can we please kill zImage?  In addition to be completely useless for
modern kernels, it causes unnecessary complexity in boot loaders.

	-hpa
