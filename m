Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYIYIjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYIYIjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIYIjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:39:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57707 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYIYIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:39:13 -0400
Date: Thu, 25 Sep 2008 10:39:03 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: Milton Miller <miltonm@bga.com>, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
 hardirq preemption
Message-ID: <20080925103903.3581226f@bull.net>
In-Reply-To: <1222331779.8277.183.camel@pasglop>
References: <200809231743.23828.ossthema@de.ibm.com>
	<20080915100406.342e027a@bull.net>
	<200809240958.m8O9wM7k010996@sullivan.realtime.net>
	<1222251467.8277.73.camel@pasglop>
	<20080924143552.29a14f10@bull.net>
	<1222290917.8277.83.camel@pasglop>
	<20080925091827.29b5087c@bull.net>
	<1222327361.8277.179.camel@pasglop>
	<20080925094231.442a4c75@bull.net>
	<1222331779.8277.183.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 18:36:19 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> >   Do you mean creating a custom fasteoi handler into xics.c? Also, it's
> > not clear to me from looking at the code how you go about changing the
> > cpu priority.
> 
> Yup. I think the priority is the CPPR.. Milton can give you more
> details, if not, I'll pick it up tomorrow when at the office.
> 

  Thanks Ben, will look into this.

  Nite

  Sebastien.

