Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZJPQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZJPQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZJPQxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:53:52 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:39150 "EHLO
	sorrow.cyrius.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZJPQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:53:51 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 12:53:51 EDT
Date: Fri, 16 Oct 2009 17:25:04 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, khilman@deeprootsystems.com,
       venkatesh.pallipadi@intel.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] CPUidle: always return with interrupts enabled
Message-ID: <20091016162504.GC1391@deprecation.cyrius.com>
References: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
 <200909302321.33088.rjw@sisk.pl>
 <20091006133456.5177a32a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006133456.5177a32a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-10-06 13:34]:
> Rigor mortis is setting in on this one.

> The patch seems correct to me.

Can someone put this patch in now?  The problem has also been reported
on Marvell's Kirkwood platform (ARM) by a number of users and the
patch fixes it.

Tested-by: Martin Michlmayr <tbm@cyrius.com>

Please CC stable when you commit the patch since it also needs to go
in for 2.6.31.

Reference with the patch: http://patchwork.kernel.org/patch/50728/
-- 
Martin Michlmayr
http://www.cyrius.com/
