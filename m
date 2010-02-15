Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0BOWBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:01:41 -0500
Received: from thunk.org ([69.25.196.29]:47755 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab0BOWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:01:39 -0500
Date: Mon, 15 Feb 2010 17:01:34 -0500
From: tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Cc: Leonard Michlmayr <leonard.michlmayr@gmail.com>,
       Andreas Dilger <adilger@sun.com>,
       ext4 development <linux-ext4@vger.kernel.org>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>,
       474597@bugs.launchpad.net
Subject: Re: [PATCH 2.6.32.7] ext4: number of blocks for fiemap
Message-ID: <20100215220134.GP5337@thunk.org>
Mail-Followup-To: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	Leonard Michlmayr <leonard.michlmayr@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org Mailinglist" <linux-kernel@vger.kernel.org>,
	474597@bugs.launchpad.net
References: <1257360161.22057.16.camel@michlmayr>
 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
 <1257371050.13852.28.camel@michlmayr>
 <4B701793.9010005@canonical.com>
 <1266000136.4310.36.camel@michlmayr>
 <4D0CB743-94B6-49AB-B838-BCDD2EC8C3ED@sun.com>
 <1266016801.27587.13.camel@michlmayr>
 <20100215195001.GN5337@thunk.org>
 <4B79AF7F.2030209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B79AF7F.2030209@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 02:33:03PM -0600, Eric Sandeen wrote:
> tytso@mit.edu wrote:
> > Sorry for the delay in attending to this patch.  This is what I've
> > added to the ext4 patch queue.
> > 
> > 						- Ted
> > 
> > commit 7f9aeb212e41ea20f61061d51ad11ee2449853f1
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Mon Feb 15 14:48:32 2010 -0500
> 
> Ted, it looks like perhaps you accidentally reassigned authorship for
> this patch?

Oops, I forgot the fix the ownership when I applied the patch.  Fixed.

      	       	       	   	     - Ted
