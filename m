Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZB0VvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZB0VvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757871AbZB0VvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:51:12 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61612 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336AbZB0VvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BSy2ov3DkyMV4dg2plPqbkm2bAXdEc455VCBD73JnXfaizbloByywU4QhFp8ba0OvJ
         Wp7xjFbf9TTaS0mkjRwcEbp0VlkwIgb35DtGJYmiEB3oIEoY+QCnGJBzZN7EVYx6hIQ7
         u8M1FGSDn3IIl6N0twiXSjT62HTBUVJqejrAQ=
Date: Sat, 28 Feb 2009 00:57:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090227215749.GA3453@x200.localdomain>
References: <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <20090226223112.GA2939@x200.localdomain> <1235751298.26788.372.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235751298.26788.372.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 08:14:58AM -0800, Dave Hansen wrote:
> On Fri, 2009-02-27 at 01:31 +0300, Alexey Dobriyan wrote:
> > > I think the main question is: will we ever find ourselves in the 
> > > future saying that "C/R sucks, nobody but a small minority uses 
> > > it, wish we had never merged it"? I think the likelyhood of that 
> > > is very low. I think the current OpenVZ stuff already looks very 
> > > useful, and i dont think we've realized (let alone explored) all 
> > > the possibilities yet.
> > 
> > This is collecting and start of dumping part of cleaned up OpenVZ C/R
> > implementation, FYI.
> 
> Are you just posting this to show how you expect c/r to look eventually?
> Or are you proposing this as an alternative to what Oren has bee
> posting?

This is under discussion right now.
