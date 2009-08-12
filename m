Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZHLUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZHLUZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZHLUZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:25:50 -0400
Received: from kroah.org ([198.145.64.141]:35878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZHLUZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:25:49 -0400
Date: Wed, 12 Aug 2009 13:24:38 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Upstream revion 4 for RAR Register; include changes
 due to debugging July 7, 2009
Message-ID: <20090812202438.GB1372@kroah.com>
References: <1249664535-29690-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249664535-29690-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 10:02:15AM -0700, Mark Allyn wrote:
>  For the upstream community, this is revision 3. Changes are the
>  relocation of this driver to the staging area and add TODO file

Then why did you label this "revision 4"?

Is this different from what is currently in linux-next?  If so, can you
send a patch to bring what we have in linux-next up to this version?

thanks,

greg k-h
