Return-Path: <linux-kernel-owner+w=401wt.eu-S966371AbYD1TNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966371AbYD1TNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbYD1TN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:13:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50122 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbYD1TNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:13:24 -0400
Date: Mon, 28 Apr 2008 21:13:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428191357.GB13400@uranus.ravnborg.org>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com> <20080428123809.GD27997@elte.hu> <20080428133756.GJ16379@cs181133002.pp.htv.fi> <90edad820804280643p43509911gd7b497131c3f5004@mail.gmail.com> <20080428135957.GK16379@cs181133002.pp.htv.fi> <20080428150156.GA7412@elte.hu> <20080428185608.GZ2813@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428185608.GZ2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:56:08PM +0300, Adrian Bunk wrote:
> On Mon, Apr 28, 2008 at 05:01:56PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Mon, Apr 28, 2008 at 05:43:25PM +0400, Dmitri Vorobiev wrote:
> > > > 2008/4/28 Adrian Bunk <bunk@kernel.org>:
> > > > >
> > > > >  /me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
> > > > >     that contains a superset of the first patch
> > > > >     (and got no response at all)
> > > > 
> > > > Adrian, I am sorry for duplicating your work. The clash wasn't 
> > > > intentional: I did not notice your earlier patch in the high traffic 
> > > > of this mailing list.
> > > 
> > > No problem, and I'm actually more interested why my patch got lost.
> > 
> > It's simple: in this case i had two patches in my backlog, one from a 
> > new person and one from a frequent contributor - doing the very same 
> > change. I preferred the newbie's patch, to encourage Dmitri to keep 
> > contributing to Linux and to help him learn from the experience of 
> > working with various Linux maintainers.
> >...
> 
> Every maintainer except you will teach the newbie where to find the 
> current tree to avoid duplicating work...
I have seen Ingo referring to his README file countless number of
times which describes where to locate the x86.git tree and
how to pull it. So has you.

	Sam
