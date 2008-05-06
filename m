Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbYEFVFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbYEFVFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbYEFVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:05:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765736AbYEFVFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:05:25 -0400
Date: Tue, 6 May 2008 14:04:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       mhoffman@lightlink.com
Subject: Re: ibmaem driver status?
Message-Id: <20080506140433.0fa6e68e.akpm@linux-foundation.org>
In-Reply-To: <20080505230440.GE16404@tree.beaverton.ibm.com>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
	<20080505230440.GE16404@tree.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 16:04:40 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> On Mon, May 05, 2008 at 01:56:21PM -0700, Andrew Morton wrote:
> > On Fri, 2 May 2008 21:55:59 -0700
> > "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > 
> > > Minor rework to support the Intel 5400 chipset.
> > 
> > Thanks, I added this to the for-git-hwmon part of the -mm queue.
> > 
> > I haven't heard from Mark for quite some time so soon I might declare him
> > absent and I'll go through my hwmon patches with a view to merging them into
> > 2.6.26 directly.
> 
> Jean/Mark:
> 
> Any thoughts on merging the ibmaem driver?  I haven't heard anything in
> a good week and a half; if it's in Mark's backlog that's not a problem.
> (Or at least not as big of one as "silently bitrotting" :))
> 

Am just looking at it now.  Your email was mysteriously truncated partway
through the patch.  Resend, please.

