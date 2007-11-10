Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXKJNlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXKJNlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 08:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXKJNlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 08:41:25 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:58646 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbXKJNlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 08:41:23 -0500
Date: Sat, 10 Nov 2007 14:41:13 +0100 (CET)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
In-Reply-To: <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se>
Message-ID: <Pine.A41.4.64.0711101437570.688212@stalin.acc.umu.se>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
 <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
 <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se>
 <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Bo Brantén wrote:

>
> After I uppgraded the BIOS the mtrr looks like below, and now it works if I 
> boot with mem=4736M so I can use all memory but it still doesn't work without 
> the mem parameter then it will run as slow as before.

I noticed that after I uppgraded the BIOS it works automtically without 
the mem parameter with kernel 2.6.22-14 while with kernel 2.6.19 the mem 
parameter is still needed so some fix has been added that takes care of 
this problem.
