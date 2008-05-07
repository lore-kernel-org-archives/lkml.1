Return-Path: <linux-kernel-owner+w=401wt.eu-S1764176AbYEGHaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764176AbYEGHaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYEGHaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:30:13 -0400
Received: from www.tglx.de ([62.245.132.106]:54296 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYEGHaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:30:11 -0400
Date: Wed, 7 May 2008 09:26:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: monstr@seznam.cz
cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 37/56] microblaze_v2: headers for irq
In-Reply-To: <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
Message-ID: <alpine.LFD.1.10.0805070925000.3318@apollo.tec.linutronix.de>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu> <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu> <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu> <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu> <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu> <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu> <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu> <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu> <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> +static inline void hw_resend_irq(struct hw_interrupt_type *h, unsigned int i)
> +{
> +	/* Nothing to do */

And used nowhere

> +}
> +

Thanks,
	tglx

