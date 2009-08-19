Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZHSO66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZHSO66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZHSO66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:58:58 -0400
Received: from relais.videotron.ca ([24.201.245.36]:63015 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZHSO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:58:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 19 Aug 2009 10:58:50 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Dhaval Vasa <dhaval.vasa@einfochips.com>, linux-kernel@vger.kernel.org,
       rabeeh@marvell.com, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] [ARM] Kirkwood: Marvell OpenRD-Base board support added
 to v2.6.31-rc5
In-reply-to: <20090819161859.5546c627@marrow.netinsight.se>
Message-id: <alpine.LFD.2.00.0908191053250.6044@xanadu.home>
References: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com>
 <20090819151814.7167bad0@marrow.netinsight.se>
 <4A8C02E9.2090701@einfochips.com>
 <20090819161859.5546c627@marrow.netinsight.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Simon Kagstrom wrote:

> On Wed, 19 Aug 2009 19:19:29 +0530
> Dhaval Vasa <dhaval.vasa@einfochips.com> wrote:
> 
> > >> +static unsigned int openrd_base_mpp_config[] __initdata = {
> > >> +	MPP29_GPIO,	
> > >                    ^^^^^
> > > There is trailing whitespace on this line
> > > 
> > Nicolas has already applied this patch on his orion tree; it would be 
> > worth generating separate one for whitespace ?  Suggest.

I did apply it with --whitespace=fix so no problem there.

> Maybe not, I'm not sure what the procedure is. I didn't realise it was
> already there - I was looking at another git tree :-)

It is also in RMK's git tree waiting for the 2.6.32 merge window to 
open.


Nicolas
