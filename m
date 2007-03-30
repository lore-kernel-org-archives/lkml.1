Return-Path: <linux-kernel-owner+w=401wt.eu-S1945916AbXC3Dte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945916AbXC3Dte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945925AbXC3Dte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:49:34 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58814 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945916AbXC3Dtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:49:33 -0400
Date: Fri, 30 Mar 2007 05:49:14 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Conke Hu <conke.hu@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Use C++ in kernel module?
In-Reply-To: <5767b9100703292037n57a09807qb07c20fe589273e@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703300547010.31834@yvahk01.tjqt.qr>
References: <5767b9100703292037n57a09807qb07c20fe589273e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 11:37, Conke Hu wrote:
>
> Is it possible to use C++ in linux kernel module? how?
> I've tested but failed, there is an unknown symbol in the .o file from
> c++ source code.

You answered it yourself. Linux does not have a C++ runtime.
It is possible to use a very limited set of C++ features, usually not 
worth the fight.


Jan
-- 
