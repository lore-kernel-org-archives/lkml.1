Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYGQUDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYGQUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYGQUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:02:55 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9728 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbYGQUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:02:54 -0400
Date: Thu, 17 Jul 2008 14:02:52 -0600
From: Alex Chiang <achiang@hp.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Byron Stanoszek <bstanoszek@comtime.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080717200252.GB6376@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Byron Stanoszek <bstanoszek@comtime.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stoyan Gaydarov <stoyboyker@gmail.com>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <Pine.LNX.4.64.0807150938280.12665@winds.org> <20080716211427.GH31126@csclub.uwaterloo.ca> <20080717000301.GD22919@ldl.fc.hp.com> <20080717123829.GJ31126@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717123829.GJ31126@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Sorensen <lsorense@csclub.uwaterloo.ca>:
> On Wed, Jul 16, 2008 at 06:03:01PM -0600, Alex Chiang wrote:
> > The short answer is that HP-UX decided to keep major number 11 as
> > a branding decision, and has released updates such as 11i, 11i v1,
> > 11i v2, etc.
> > 
> > Most recent release was 11i v3, and if you do a uname -a, you'll
> > see that you get a "real" version, like 11.31.
> 
> So the 11 no longer has any meaning.  

Not exactly. The 11 implies an ABI/API guarantee to ISVs and some
sense of "stability" (for whatever that means) to end users.

Marketing fluff, yes, but I guess some people out there do care
about that stuff.

/ac

