Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXGLXCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXGLXCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXGLXCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:02:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:6092 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbXGLXCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=e58Og9IvWf1aLMnIFMDMtGiEDYupsg5u4lsWCal2lcan4uSl0QFxDNeEFsWWjJUXBGxLC5Yt4yYcwE7w7bXbR+jbq6NCCeP2rWb36k+4PlcpLYtqIoMy2+rR4Ped65wnOefZNxdbHuFJH5N2ikJuXuTsZTgeasNSR9TvORLq4a8=
Date: Fri, 13 Jul 2007 01:02:25 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.22.1
Message-ID: <20070712230225.GB25937@raptus.dandreoli.com>
Mail-Followup-To: Chris Wright <chrisw@sous-sol.org>,
	Nish Aravamudan <nish.aravamudan@gmail.com>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
References: <20070710200637.GA5881@kroah.com> <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <20070712184106.GA22849@kroah.com> <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com> <20070712185219.GR4306@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712185219.GR4306@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 11:52:19AM -0700, Chris Wright wrote:
> * Nish Aravamudan (nish.aravamudan@gmail.com) wrote:
> > On 7/12/07, Greg KH <greg@kroah.com> wrote:
> > > That is a tree that Chris did, and I didn't realize we were maintaining
> > > it as the "official" stable tree, that is why it is not mentioned in the
> > > release notes :)
> > 
> > Fair enough -- it's just a little bit easier from my side for
> > mirroring to only have to mirror one tree rather simply rather than
> > pulling multiple trees into one (and thus having to add to the list as
> > time goes on).
> > 
> > > I'll let Chris decide if he wishes to maintain it or not, Chris?
> 
> Nish, I think you might be the only user ;-)  I never figured out a nice
> way to do this w/out having a coherency issue (well, triggers aside).
> Ideally git would allow for something more transparent than
> alternatives, actual moving view to another tree.  It's possible with
> links, but that seems just dirty.  Short of that, do folks find the tree
> useful?  If so, I can work on some better automation to keep it
> up-to-date.

yes, please keep it (updated). i discovered it only few days ago...

many thanks anyway,
domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
