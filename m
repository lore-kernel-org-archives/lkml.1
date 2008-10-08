Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYJHOWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYJHOWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYJHOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:22:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYJHOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:22:43 -0400
Date: Wed, 8 Oct 2008 10:22:21 -0400
From: Dave Jones <davej@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Message-ID: <20081008142221.GA3054@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <200810080218.18898.nickpiggin@yahoo.com.au> <20081007153203.GB3337@redhat.com> <200810081524.40614.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810081524.40614.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 03:24:40PM +1100, Nick Piggin wrote:
 
 > >  > If that helps, can you try adding some printks to narrow down where it
 > >  > is getting stuck?
 > >
 > > This is going to sound strange, but I've forgotten which box that was.
 > > I'm due to reinstall all my test boxes now that the next Fedora beta
 > > has come out anyway, so I'll hopefully figure out by the end of the week :)
 > 
 > That does sound strange ;) But I can't believe that! It would be really
 > interesting if it was stuck in calibrate_delay, but maybe the backtrace
 > is just messed up...
 > 
 > If you do manage to reproduce it, I would be quite interested. Otherwise,
 > I think we can say it's not a showstopper for 2.6.27.

agreed.  I clearly have too many other shiny toys.

	Dave

-- 
http://www.codemonkey.org.uk
