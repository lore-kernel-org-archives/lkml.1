Return-Path: <linux-kernel-owner+w=401wt.eu-S972053AbXHMN3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972053AbXHMN3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970698AbXHMJ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:29:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970672AbXHMJ3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:29:18 -0400
Date: Mon, 13 Aug 2007 11:29:16 +0200
From: Jan Blunck <jblunck@suse.de>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] dm-snap: Remove dead queued_bios code
Message-ID: <20070813092916.GD12730@hasse.suse.de>
References: <20070810200204.455820246@suse.de>> <20070810200205.299669010@suse.de> <20070810204337.GH2064@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810204337.GH2064@agk.fab.redhat.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, Alasdair G Kergon wrote:

> On Fri, Aug 10, 2007 at 10:02:07PM +0200, Jan Blunck wrote:
> > This patch removes the unused queued_bios handling code.
>  
> Well I'm going to leave this in for now (as one existing unfinished
> patch series does build upon it).  We can include its removal as part of
> your following patch series that no doubt replaces the functionality
> with something better.

You mean the snapshot read tracking. Yes, I think I can fix this problem too.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
