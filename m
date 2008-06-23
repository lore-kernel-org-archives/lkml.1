Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYFWRBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYFWRBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbYFWRA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:00:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbYFWRAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:00:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: rpeterso@redhat.com
Subject: Re: [Cluster-devel] Re: [Bug 10827] 2.6.26rc4 GFS2 oops.
Date: Mon, 23 Jun 2008 19:02:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, cluster-devel@redhat.com,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Whitehouse <swhiteho@redhat.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <20080623151417.GA28779@cs181140183.pp.htv.fi> <1214235162.3724.71.camel@technetium.msp.redhat.com>
In-Reply-To: <1214235162.3724.71.camel@technetium.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231902.16412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 of June 2008, Bob Peterson wrote:
> > Yup, the patch in your Bugzilla is for code that is new in 2.6.26.
> > 
> > Can you push your patch for inclusion into 2.6.26 so that 2.6.26 won't 
> > get released with this regression?
> > 
> > Thanks
> > Adrian
> 
> Hi Adrian,
> 
> Unfortunately, I cannot.  All access to the gfs2 "-nmw" git tree is
> controlled by Steve Whitehouse, and he is on vacation/holiday until
> tomorrow.
> 
> I've submitted the patch to cluster-devel, so hopefully he'll push it
> as soon as he returns tomorrow.

You can post the patch in this thread, with CC to Andrew Morton.

Thanks,
Rafael
