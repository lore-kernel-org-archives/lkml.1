Return-Path: <linux-kernel-owner+w=401wt.eu-S1764965AbXGJJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764965AbXGJJdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764195AbXGJJai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:30:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:6548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294AbXGJJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:30:37 -0400
Date: Tue, 10 Jul 2007 11:30:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Ni@m" <niam.niam@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmware modules with 2.6.22
In-Reply-To: <a9e22dff0707100223y5676ca63h7aaab05a660ed81d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707101127390.11053@fbirervta.pbzchgretzou.qr>
References: <a9e22dff0707100223y5676ca63h7aaab05a660ed81d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10 2007 12:23, Ni@m wrote:

> Hi! I have  problem building vmware modules with 2.6.22.

Tell that VMware, this is the wrong place.

> During code investigation I've notiesd that vmware modules are using
> old sk_buff structure
>
> /////
> skb->h.raw != skb->nh.raw
> /////
>
> how can I modify code to be able to compile it and where can I read
> migration guide for sk_buff?

Get http://platan.vc.cvut.cz/ftp/pub/vmware/vmware-any-any-update110.tar.gz



	Jan
-- 
