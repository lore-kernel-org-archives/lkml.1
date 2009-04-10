Return-Path: <linux-kernel-owner+w=401wt.eu-S936567AbZDJMb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936567AbZDJMb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZDJMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:31:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753495AbZDJMbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:31:15 -0400
Date: Fri, 10 Apr 2009 07:31:11 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] GRU - GRU Driver updates
Message-ID: <20090410123111.GA9897@sgi.com>
References: <20090406160809.278924000@sgi.com> <20090409153701.d8bf4c20.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409153701.d8bf4c20.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 03:37:01PM -0700, Andrew Morton wrote:
> On Mon, 06 Apr 2009 11:08:09 -0500
> steiner@sgi.com wrote:
> 
> > 
> > This patchset is a collection of patches to the GRU driver.
> > All changes are internal to the driver and have no effect
> > on the core kernel or interfaces to/from the core kernel.
> 
> Do you believe that any of these should go into 2.6.30, or earlier?

The patches are desirable for 2.6.30 but nothing earlier. Since all
are internal to the GRU driver and do not affect anything outside of the
core driver, they should be safe.


--- jack
