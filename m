Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXFJJjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXFJJjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbXFJJgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:36:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:35209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbXFJJgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:36:44 -0400
From: Neil Brown <neilb@suse.de>
To: Tarkan Erimer <tarkan@netone.net.tr>
Date: Sun, 10 Jun 2007 19:36:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18027.50727.190221.80822@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: message from Tarkan Erimer on Sunday June 10
References: <466A3EC6.6030706@netone.net.tr>
	<18026.16739.228277.938421@notabene.brown>
	<466BBB0B.4050303@netone.net.tr>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday June 10, tarkan@netone.net.tr wrote:
> Hi Neil,
> 
> Neil Brown wrote:
> > On Saturday June 9, tarkan@netone.net.tr wrote:
> >   
> >> Hi,
> >>
> >> As we know the forthcoming GPL V3 will be not compatible with the GPL V2 
> >> and Linux Kernel is GPL V2 only.
> >> So, another point is, which is previously mentioned by Linus and others, 
> >> that if it is decided to upgrade the Linux Kernel's License to GPL V3, 
> >> it is needed the permission of all the maintainers permission who 
> >> contributed to the Linux Kernel and there are a lot of lost or dead 
> >> maintainers. Which makes it impossible to get all the maintainers' 
> >> permission.
> >>     
> >
> > You don't need the permission of maintainers.  You need the permission
> > of copyright owners.  The two groups overlap, but are not the same.
> > Dead people cannot own anything, even copyright.  Their estate
> > probably can.  I don't think it is theoretically impossible to get
> > everyone's permission, though it may be quite close to practically
> > impossible. 
> >
> >   
> So, does it mean we can change the license of the dead people's code ?
> 

I presume the heirs of the dead people could change the license.  And
if they have no heir, then there is no-one to sue for breach of
copyright, so I assume the copyright lapses.

And I wouldn't be surprised if there were some legal precedent that
allowed for some process whereby we could make a "best effort" to
contact copyright holders (including registered paper letters and
entries in the "Public Notices" section of major newspapers) and if
no-one stepped forward to claim copyright in a reasonable period of
time we could assume that the copyright had lapsed.  But you would
need to ask a lawyer, and it would be different in different
countries.

But I think this is largely academic.  You only need a fairly small
number of fairly significant contributors to say "no" and the rest of
the process would be pointless.  And at last count, the number of
kernel people who were not keen on GPLv3 was fairly high.  Of course
no-one knows for certain yet what the final GPLv3 will be, and maybe
lots of people would change their mind when it comes out.

There would certainly be value in a straw-pole once GPLv3 was out and
had been discussed for a while - to see if a license change to GPLv3
would be accepted by a majority of current developers.  Doing that
would at least provide a clear statistic to point people at.

NeilBrown
