Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXFPDXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXFPDXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXFPDXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:23:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33025
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbXFPDXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:23:03 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 23:22:59 -0400
User-Agent: KMail/1.9.6
Cc: Carlo Wood <carlo@alinoe.com>, Daniel Hazelton <dhazelton@enter.net>,
       Bernd Paysan <bernd.paysan@gmx.de>, Theodore Tso <tytso@mit.edu>,
       Alexandre Oliva <aoliva@redhat.com>, Sean <seanlkml@sympatico.ca>,
       Adrian Bunk <bunk@stusta.de>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org> <20070615164347.GA4952@alinoe.com> <alpine.LFD.0.98.0706151101020.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706151101020.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152323.01489.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 14:15:58 Linus Torvalds wrote:
> On Fri, 15 Jun 2007, Carlo Wood wrote:
> > The point is: can you, or can't you (legally) relicense the whole kernel
> > tree under the GPLv3 (or GPLv2+GPLv3)?
>
> No. My special rights do not actually give me those kinds of powers,
> exactly because I'm bound by my _other_ agreement (namely the GPLv2) to
> follow the license of the code that other people have sent me.
>
> > At first I thought that you cannot, because too many (significant)
> > contributors have been involved (and you will never get signatures from
> > them all). Then someone surprised me by claiming that the original author
> > had copyright for everything - even files added by others.
>
> Both are true facts, but the "copyright for everything" is a *separate*
> kind of copyright, which does not include the right to relicense. It's
> literally the "copyright in the collective".
>
> For examples of the US rules, see USC 17.2.201(c) ("Ownership of
> copyright" and " Contributions to Collective Works"), which spells out
> some limited special rights that I have (namely the right to reproduce and
> distribute).

http://www.copyright.gov/title17/92chap2.html#201

There are some really interesting bits in Chapter 1 too...

http://www.copyright.gov/title17

> entirely sure about certain special cases. In particular, if somebody
> tried to _revoke_ the rights to their code under the GPLv2,

There's no revocation clause in the license.  They can't.  (SCO would have 
tried to revoke Caldera's license to its contributions it if it were at all 
possible.)

> I suspect that 
> my rights in the collective would protect me from that and allow me to
> still distribute the code in question, since _those_ rights cannot be
> revoked, and they are _mine_).

Title 17 chapter 1 section 103(a) seems to lean against this.  I think it says 
that having rights to the collective is conditional on having had the rights 
to the components of that collective.

> So only in the case of some really obscure and unclear situations, I _may_
> have more rights than some other people, but trust me, but that is damn
> murky, and you'd better have a good lawyer state it, not just a programmer
> who has talked to too many lawyers..

Entirely agreed. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
