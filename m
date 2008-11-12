Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbYKLARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbYKLARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKLARh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:17:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:35455 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751825AbYKLARg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:17:36 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+Xu0xklT+Xc/n/olBJ7Rsl51e9EEMKtnmPNhp2u4
	Uxgbq5r+O+VlIT
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch hfsplus-check-read_mapping_page-return-value.patch added to 2.6.27-stable tree
Date: Wed, 12 Nov 2008 01:17:29 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20081111213503.5262649038@coco.kroah.org>
In-Reply-To: <20081111213503.5262649038@coco.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811120117.34978.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Dienstag, 11. November 2008, gregkh@suse.de wrote:
> 
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: hfsplus: check read_mapping_page() return value (CVE-2008-4934)
> 
> to the 2.6.27-stable tree.  Its filename is
> 
>     hfsplus-check-read_mapping_page-return-value.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 649f1ee6c705aab644035a7998d7b574193a598a Mon Sep 17 00:00:00 2001
> From: Eric Sesterhenn <snakebyte@gmx.de>
> Date: Wed, 15 Oct 2008 22:04:10 -0700
> Subject: hfsplus: check read_mapping_page() return value (CVE-2008-4934)
> 
> From: Eric Sesterhenn <snakebyte@gmx.de>
> 
> commit 649f1ee6c705aab644035a7998d7b574193a598a upstream.

This exact patch is already present in 2.6.27.5 and subsequently fails to 
apply.

Regards
	Stefan Lippers-Hollmann
