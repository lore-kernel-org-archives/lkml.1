Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZF3Xjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZF3Xjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbZF3Xj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:39:29 -0400
Received: from kroah.org ([198.145.64.141]:59665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483AbZF3Xj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:39:28 -0400
Date: Tue, 30 Jun 2009 16:39:12 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Thomas Renninger <trenn@suse.de>, stable@kernel.org,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, rjw@sisk.pl, penberg@cs.helsinki.fi,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, davej@redhat.com,
       mingo@elte.hu, kernel-testers@vger.kernel.org
Subject: Re: [stable] [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from
	ondemand and conservative governors
Message-ID: <20090630233912.GA3709@kroah.com>
References: <20090623193215.GA31374@elte.hu> <1245938485-12663-2-git-send-email-trenn@suse.de> <20090630225813.GB2634@kroah.com> <20090630231452.GA23217@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630231452.GA23217@Krystal>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 07:14:52PM -0400, Mathieu Desnoyers wrote:
> * Greg KH (greg@kroah.com) wrote:
> > I don't see the patch below in Linus's tree.  If it's there, what is the
> > git commit id?
> > 
> 
> As I pointed out in an earlier reply, this patch is bogus and adds racy
> data structure updates. It should not be merged.

Ok, dropped.

thanks,

greg k-h
