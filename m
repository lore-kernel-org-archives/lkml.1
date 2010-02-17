Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0BQUCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:02:21 -0500
Received: from mail-qy0-f178.google.com ([209.85.221.178]:43462 "EHLO
	mail-qy0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab0BQUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WRexowVf8Vfx/Y5BdOAl5ggZJuY8AFnmnzBR2jOMYUgPBSWupLIo6cA0msMJJNmBO3
         Pq1ixEqBoMr4lNirlBOCuf7XQc8sBI20xPyrIkDg6ajMr2FcESnVsnGBPSaqeCPT0cHG
         9063oAN3rRfPMSfxOUqlEL5oOQFsGpnDnGv+I=
Date: Wed, 17 Feb 2010 12:02:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Matthias Petermann <matthias@d2ux.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: Synaptics touchpad doesn't click (refers thread from December
 2009)
Message-ID: <20100217200214.GA1948@core.coreip.homeip.net>
References: <4B7B1229.4030008@d2ux.org>
 <20100217194902.GA28560@ldl.fc.hp.com>
 <20100217195626.GC32353@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217195626.GC32353@ldl.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 12:56:26PM -0700, Alex Chiang wrote:
> Sigh, sorry. I fat-fingered Dmitry's email address.
> 

Arhg, lost track of it in my INBOX, so not merged yet, sorry.

> * Alex Chiang <achiang@hp.com>:
> > Adding cc's.
> > 
> > /ac
> > 
> > * Matthias Petermann <matthias@d2ux.org>:
> > > Hi,
> > >
> > > around mid December 2009 there was a thread with the same topic as in my  
> > > subject on LKML. Initially there were reported click-problems with the  
> > > Synaptics Trackpad-Click like it is present with current HP Envy 13 and  
> > > 15 Notebooks.
> > >
> > > Dmitry Torokhov stated some very promising patch sets here in this list  
> > > and so far some other persons like Alex Chiang reported success with  
> > > them. Especially I refer to [1].
> > >
> > > Can anyone give a short update what happens to this patches? Are they  
> > > fully merged into 2.6.33-rc8? I tried to match the code of the patch  
> > > with it but it looks quite different from my novices eye ;-)
> > >
> > >
> > > Thanks,
> > > Matthias
> > >
> > >
> > >
> > > [1] http://lkml.org/lkml/2009/12/15/29
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

-- 
Dmitry
