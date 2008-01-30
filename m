Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYA3Nje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYA3Nje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYA3NjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:39:15 -0500
Received: from trinity.phys.uwm.edu ([129.89.57.159]:44599 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYA3NjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:39:13 -0500
Date: Wed, 30 Jan 2008 07:38:56 -0600 (CST)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
       Andi Kleen <andi@firstfloor.org>,
       Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
In-Reply-To: <p73ve5b5u5v.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.63.0801300736040.10711@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
 <p73ve5b5u5v.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Thanks for the reply.

> You forgot to specify what user programs you used to get to the 
> benchmark results. e.g. if the user space does not use large enough 
> reads/writes then performance will be not optimal.

We used netperf (as stated in the first paragraph of the original post). 
Tell us if you want the command line.  Previous testing with older kernels 
and broadcom NICS has shown full-duplex wire speed.

> Also best you repost your results with full information on 
> netdev@vger.kernel.org

Wilco.  Just subscribing now.

Cheers,
 	Bruce
