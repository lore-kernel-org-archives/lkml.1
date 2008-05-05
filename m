Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbYEEXFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbYEEXFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760919AbYEEXE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:04:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54798 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760915AbYEEXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:04:23 -0400
Date: Mon, 5 May 2008 16:04:40 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       mhoffman@lightlink.com
Subject: ibmaem driver status?
Message-ID: <20080505230440.GE16404@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20080503045558.GJ16078@tree.beaverton.ibm.com> <20080505135621.66809b0e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505135621.66809b0e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 01:56:21PM -0700, Andrew Morton wrote:
> On Fri, 2 May 2008 21:55:59 -0700
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > Minor rework to support the Intel 5400 chipset.
> 
> Thanks, I added this to the for-git-hwmon part of the -mm queue.
> 
> I haven't heard from Mark for quite some time so soon I might declare him
> absent and I'll go through my hwmon patches with a view to merging them into
> 2.6.26 directly.

Jean/Mark:

Any thoughts on merging the ibmaem driver?  I haven't heard anything in
a good week and a half; if it's in Mark's backlog that's not a problem.
(Or at least not as big of one as "silently bitrotting" :))

--D
