Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZIUXuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZIUXuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 19:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZIUXuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 19:50:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37494 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZIUXuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 19:50:22 -0400
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
From: Keith Mannthey <kmannth@us.ibm.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
In-Reply-To: <20090921145502.GC23580@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
	 <20090918144226.GD25309@aftab> <1253294933.7263.129.camel@keith-laptop>
	 <20090921145502.GC23580@aftab>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 16:50:24 -0700
Message-Id: <1253577024.7263.196.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 16:55 +0200, Borislav Petkov wrote:
> Hi Keith,
> 
> On Fri, Sep 18, 2009 at 10:28:53AM -0700, Keith Mannthey wrote:
> > > By the way, your patches made me look harder at that code region and
> > > I've found some more problems with it which I've fixed. Would you like
> > > to test the whole bunch of fixes on your setup?
> > 
> > Yes please send any changes you have.  I have a decent test setup for
> > live errors. 
> 
> The patch queue is at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git
> 
> the 'edac-fixes' branch.

Please check you have synced with that git tree.  When I pull the tree
it is 2.6.30-rc5 without the amd64_edac driver.  It has no branch
outside of "master". 


Thanks,
  Keith 

