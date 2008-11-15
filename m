Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYKOMhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYKOMhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 07:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYKOMgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 07:36:54 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:20567 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYKOMgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 07:36:53 -0500
Message-ID: <491EC263.9020707@msgid.tls.msk.ru>
Date: Sat, 15 Nov 2008 15:36:51 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: k10temp driver in kernel?
References: <491EAA25.9050606@xs4all.nl>
In-Reply-To: <491EAA25.9050606@xs4all.nl>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Hello,
> 
> What is the status of the k10temp driver?
> When will it be in the kernel?

The driver missed 2.6.28 merge window for a bit.
So it might be in 2.6.29.  In any way, it's quite
easy to compile it out of tree.

/mjt
