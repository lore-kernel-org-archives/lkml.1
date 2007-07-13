Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbXGMLo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbXGMLo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXGMLoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:44:19 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:60018 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXGMLoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:44:18 -0400
Subject: Re: Documentation of kernel messages (Summary)
From: Li Yang <leoli@freescale.com>
Reply-To: leoli@freescale.com
To: Rob Landley <rob@landley.net>, gregkh@suse.de
Cc: Gerrit Huizenga <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
In-Reply-To: <200707121335.55817.rob@landley.net>
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
	 <200707121335.55817.rob@landley.net>
Content-Type: text/plain
Organization: Freescale Semiconductor
Date: Fri, 13 Jul 2007 19:54:37 +0800
Message-Id: <1184327677.23373.51.camel@Gundam>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2007 11:44:11.0586 (UTC) FILETIME=[21522220:01C7C543]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 13:35 -0400, Rob Landley wrote:
> On Thursday 12 July 2007 9:53:54 am Li Yang-r58472 wrote:
> > > Fielding patches and questions sounds like plenty to me...)
> >
> > I do think the documentation translation is very necessary even when
> > there is a language maintainer, especially for the policy documents as
> > HOWTO, codestyle , and etc.  The contributors should go through these
> > policies and check their code for compliance before going to the
> > language maintainer for help, or there will be too much for the language
> > maintainer to translate.  The language maintainer doesn't need to
> > translate all the documents himself, but he can help to coordinate the
> > translation effort and help to make it update to date.
> 
> It would help if all the policy documents got grouped into a single 
> Documentation/development directory so we could separate "policy documents in 
> each language would be nice" from "that document about the amiga zorro bus 
> really needs to be kept up-to-date in Navajo and that should be in the kernel 
> tarball please".
> 
> Lemme see, which ones are we talking about?  The candidates are:
>   applying-patches.txt
>   BUG-HUNTING
>   Changes
>   CodingStyle
>   debugging-modules.txt
>   feature-removal-schedule.txt
>   HOWTO
>   kernel-docs.txt
>   language-maintainers.txt
>   ManagementStyle
>   oops-tracing.txt
>   SecurityBugs
>   sparse.txt
>   stable_api_nonsense.txt
>   stable_kernel_rules.txt
>   SubmitChecklist
>   SubmittingDrivers
>   SubmittingPatches
>   volatile-considered-harmful.txt
> 
> That's everything I noticed in the top level directory that's a good candidate 
> to be grouped into a "development" subdirectory.  Did I miss anything?
> 
> I note that Changes is a bit stale in places (16 bit assembly?), 
> feature-removal-schedule.txt changes often but is good to know, 
> kernel-docs.txt might be useless to translate considering it's mostly links 
> to english documentation, language-maintainers.txt is assuming my patch from 
> earlier today gets accepted...
> 
> I can submit a patch grouping all that stuff together into a subdirectory if 
> it would help...
> 
> > If we do need a contact person, I can do it.  However I don't think
> > there will be much translation work to do here.  As I stated before,
> > most Chinese programmers are more or less capable of read/write
> > technical English.  The difficult part is to let them know the benefit
> > of merging code in kernel and teach them how to do it.  That's why the
> > policy documents in native language will be very useful.
> 
> Does the above look like a good list?  There are more that need to be written, 
> but that's what I saw in Documentation...

Yes, I do think this is a good list for translation.

Greg,
Do you have anything to add?

- Leo


