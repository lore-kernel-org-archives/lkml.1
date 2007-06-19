Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbXFSFwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbXFSFwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXFSFwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:52:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbXFSFwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:52:13 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Al Viro <viro@ftp.linux.org.uk>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706181945.16343.dhazelton@enter.net>
	<orvedk8zpa.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706182035420.3593@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 02:51:19 -0300
In-Reply-To: <alpine.LFD.0.98.0706182035420.3593@woody.linux-foundation.org> (Linus Torvalds's message of "Mon\, 18 Jun 2007 20\:46\:44 -0700 \(PDT\)")
Message-ID: <or7iq05w6g.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The GPLv2 is the one that allows more developers. 

> The GPLv2 is the one that is acceptable to more people. 

Based on my understanding that the anti-tivoization provisions are
*the* objectionable issue about GPLv3 for those of you who dislike
GPLv3, this is circular reasoning:

  anti-tivoization is bad
  => we reject licenses with it
  => there are fewer developers willing to develop with such licenses
  => anti-tivoization is bad



> Face it, the "open source" crowd is the *bigger* crowd.

I really don't know about that.  I can believe it may be so in LKML.

> I haven't really seen a single one. Last I did the statistic, I asked the 
> top ~25-30 kernel developers about their opinion. NOT A SINGLE ONE 
> preferred the GPLv3.

Wow, that's a really big sample among all Free Software and Open
Source developers out there.  And not even a little bit biased at
that.

> So I have actual *numbers* on my side. What do you have, except for a 
> history of not actually understanding my arguments?

Which is worse, not understanding or repeatedly snipping out and
addressing unrelated points?


Let's please try again.

I'll try to keep it simple, since you can't seem to be able to grasp
the entire argument, and keep disregarding essential parts, disputing
unrelated points and jumping to the conclusions that you've disputed
the point I was trying to make.

I'll present it in parts, as an attempt to stop you from making this
mistake, that I'm sure is not intentional.

The first part is in this e-mail.


Dispute this:

non-tivoized hardware => users can scratch their itches => more
contributions from these users

tivoized hardware => users can't scratch their itches => fewer
contributions from these users


-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
