Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZCVLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZCVLFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 07:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZCVLEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 07:04:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZCVLEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 07:04:51 -0400
Subject: Re: Test some kernel feature without recompile
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
References: <2d05c4580903220343l4b1359fx79f18b56203bd463@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 16:34:37 +0530
Message-Id: <1237719877.3223.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-22 at 11:43 +0100, Dragoslav Zaric wrote:
> Hi,
> 
> I know when you work on some kernel module, you can change code and load
> module again and test it, but what if you change some built in kernel
> .c file, why
> would I need to recompile whole kernel just to see what happens if I change one
> .c file ??
> 
> Why can I just compile one changed .c file and copy it where compiled version of
> that file reside inside kernel tree? Or maybe there is some image info embedded
> inside compiled files, so that file must belong to specific image from
> which it is
> installed ?
> 

hmm, everything is possible. If you want this feature then place an
order ;-)

Just curious do you want to reboot your system or you also want to see
the effect of that file in running kernel.

--
JSR


