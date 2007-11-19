Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbXKSFmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbXKSFmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXKSFl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:41:57 -0500
Received: from [212.12.190.176] ([212.12.190.176]:45877 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbXKSFl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:41:56 -0500
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Mon, 19 Nov 2007 08:40:53 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <9qVOO-4ZK-13@gated-at.bofh.it> <alpine.LSU.0.999.0711190042340.14144@be1.lrz> <4740D28E.7080800@zytor.com>
In-Reply-To: <4740D28E.7080800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711190840.53967.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> a. For as long as we keep throwing more crap into the kernel, kinit will
> not get merged, because it "provides no new functionality."

I'm not really familiar with kinit, but it sounds unfair to hinder new 
features because it would reduce the usefulness of another project.

kinit should have nothing to fear, as its purpose would not be to add new 
features, but rather to modularize the boot process, by replacing the 
current init, and thus allow for more flexibility to add/modify features.


Thanks!

--
Al
