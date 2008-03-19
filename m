Return-Path: <linux-kernel-owner+w=401wt.eu-S1764479AbYCSXX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764479AbYCSXX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbYCSV6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:58:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964827AbYCSV6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:58:01 -0400
Date: Wed, 19 Mar 2008 17:55:10 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, sam@ravnborg.org, greg@kroah.com,
       randy.dunlap@oracle.com, giometti@linux.it
Subject: Re: LinuxPPS (RESUBMIT 2): the PPS Linux implementation.
Message-ID: <20080319215510.GB7901@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
	dwmw2@infradead.org, sam@ravnborg.org, greg@kroah.com,
	randy.dunlap@oracle.com, giometti@linux.it
References: <12048053463198-git-send-email-giometti@linux.it> <1f1b08da0803191029w6878f693l6ac24f974a088676@mail.gmail.com> <20080319142113.a1e76213.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319142113.a1e76213.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 02:21:13PM -0700, Andrew Morton wrote:
 > On Wed, 19 Mar 2008 10:29:34 -0700
 > "john stultz" <johnstul@us.ibm.com> wrote:
 > 
 > > On Thu, Mar 6, 2008 at 5:08 AM, Rodolfo Giometti <giometti@linux.it> wrote:
 > > > This patch set adds the PPS support into Linux.
 > > >
 > > >  PPS means "pulse per second" and its API is specified by RFC 2783
 > > >  (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
 > > >
 > > >  The code has been tested with the NTPD program
 > > >  (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
 > > >  antennae.
 > > 
 > > Hey Andrew,
 > >   Are there any remaining objections that are keeping you from picking
 > > this patchset up?
 > 
 > Not as far as I know.  They're in my queue-to-review.  Assistance there is
 > always useful ;)

I looked it over a few times now, and didn't find anything objectionable.
But then, your standards are always somewhat higher than mine :)

	Dave

-- 
http://www.codemonkey.org.uk
