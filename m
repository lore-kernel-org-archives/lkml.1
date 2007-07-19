Return-Path: <linux-kernel-owner+w=401wt.eu-S939950AbXGSQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939950AbXGSQ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764176AbXGSQ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:26:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38525 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758850AbXGSQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:26:17 -0400
Date: Thu, 19 Jul 2007 18:25:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719162539.GU3801@stusta.de>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <Line.LNX.4.64.0707190832290.4303@d.namei> <20070719124244.GA7219@vino.hallyn.com> <Line.LNX.4.64.0707190847020.4393@d.namei> <20070719133727.GC32313@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070719133727.GC32313@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 08:37:27AM -0500, Serge E. Hallyn wrote:
> Quoting James Morris (jmorris@namei.org):
> > On Thu, 19 Jul 2007, Serge E. Hallyn wrote:
> > 
> > > > It's already pretty clear.
> > > 
> > > I doubt anyone not on lkml or linux-security-module has heard of this.
> > > 
> > > So we'll see.
> > > 
> > > (I was, obviously, talking about end-users)
> > 
> > If distributions are shipping binary modules and other out of tree code to 
> > their users, then they should bear responsibility for supporting and 
> > maintaining the infrastructure required for it, and not expect upstream 
> > maintainers to do it for them.
> > 
> > Additionally, if they want to expose their users to risks arising from 
> > broken and unecessary infrastructure, then they should bear the cost and 
> > responsibility of doing that and not expect others to do so as well.
> > 
> > I don't see how this is even slightly difficult to understand.
> 
> I'm not talking about distros - I don't see how this is even slightly
> difficult to understand  :)
> 
> The situation I have in mind is someone who decideds to use, say, SLIM,
> but wants to otherwise use the distro kernel.
>...

AFAIR this does anyway not work because at least the version of SLIM 
that once was in -mm required some patching of the kernel.

> -serge

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

