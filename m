Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZA3VV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZA3VV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZA3VVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:21:17 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:32826 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615AbZA3VVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:21:17 -0500
Date: Fri, 30 Jan 2009 16:21:16 -0500
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Catalin(ux) M. BOIE" <catab@embedromix.ro>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Seagate disk freeze for 30 seconds then comes back (RecovComm 10B8B)
Message-ID: <20090130212115.GB26062@csclub.uwaterloo.ca>
References: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro> <20090128153141.GC26064@csclub.uwaterloo.ca> <498244D4.4060903@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498244D4.4060903@tmr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 07:07:48PM -0500, Bill Davidsen wrote:
> Would you expect that firmware would be shared between old tech laptop 
> drives and desktop/server drives? Particularly since the laptop drive was 
> built before any of the 7200.11 drives?
> 
> I think this is a very unlikely part of the problem. Certainly the drive 
> might be dying or other hardware issue.

It does seem unlikely, although if it is a common design flaw in their
firmware, it could have been carried over from older drives and just not
be as noticeable on the older drives with smaller caches and less drive
space.

Now if the drive is really old, then year it might simply be failing.

-- 
Len Sorensen
