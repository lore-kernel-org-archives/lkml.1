Return-Path: <linux-kernel-owner+w=401wt.eu-S935731AbYBUW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731AbYBUW6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935488AbYBUW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:58:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:10494 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935451AbYBUW6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JifrnW+ZPJ35L+88DCCltiGXWpuPLADQgJWjMC5heXAnSolaoo0uMkChGc2qTYRbCZv0bEFIrjm38Yp4EeMzHSGYCm6IieJbyS0cACPk0XFHrLjFCoOZr0NBtEge9g56s2ulFYDkywtl1hbz2srqIphJG1td4Ioi2ERPp4vfZeU=
Date: Fri, 22 Feb 2008 01:58:17 +0300
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080221225817.GE1846@martell.zuzino.mipt.ru>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <20080221223303.GD1846@martell.zuzino.mipt.ru> <20080221224315.GA27640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221224315.GA27640@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 02:43:15PM -0800, Greg KH wrote:
> On Fri, Feb 22, 2008 at 01:33:03AM +0300, Alexey Dobriyan wrote:
> > On Thu, Feb 21, 2008 at 01:14:55PM -0800, Linus Torvalds wrote:
> > > Quite frankly, I've several times been *this* close (holds up fingers so 
> > > you can't even see between them) to just remove checkpatch entirely.
> > 
> > Agrh! What stopped you?!
> > 
> > > I'm personally of the opinion that a lot of checkpatch "fixes" are 
> > > anything but. That mainly concerns fixing overlong lines (where the 
> > > "fixed" version is usually worse than the original), but it's been true 
> > > for some other warnings too.
> > 
> > Speaking of driver, could authors please comment all those barrier()
> > calls and remove trailing "return;" at the end of void functions.
> 
> Why don't you make a patch to checkpatch.pl for those types of things?
> :)

Sorry, I'm not touching it with an eigthy six foot pole. :^)
