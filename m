Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZJPVM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZJPVM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZJPVMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:12:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbZJPVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:12:24 -0400
Date: Fri, 16 Oct 2009 14:11:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, khilman@deeprootsystems.com,
       venkatesh.pallipadi@intel.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] CPUidle: always return with interrupts enabled
Message-Id: <20091016141104.d794f2c4.akpm@linux-foundation.org>
In-Reply-To: <20091016162504.GC1391@deprecation.cyrius.com>
References: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
	<200909302321.33088.rjw@sisk.pl>
	<20091006133456.5177a32a.akpm@linux-foundation.org>
	<20091016162504.GC1391@deprecation.cyrius.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009 17:25:04 +0100
Martin Michlmayr <tbm@cyrius.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2009-10-06 13:34]:
> > Rigor mortis is setting in on this one.
> 
> > The patch seems correct to me.
> 
> Can someone put this patch in now?  The problem has also been reported
> on Marvell's Kirkwood platform (ARM) by a number of users and the
> patch fixes it.
> 
> Tested-by: Martin Michlmayr <tbm@cyrius.com>

I have it in my for-2.6.32 queue.

> Please CC stable when you commit the patch since it also needs to go
> in for 2.6.31.

hm, I didn't know that.  So noted, thanks.
