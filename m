Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYE1R5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYE1R5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYE1R5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:57:05 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35772 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYE1R5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:57:04 -0400
Date: Wed, 28 May 2008 20:57:01 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Tony Breeds <tony@bakeyournoodle.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: PPC PReP link failure - copy_page, empty_zero_page
In-Reply-To: <20080528005346.GK20457@bakeyournoodle.com>
Message-ID: <Pine.SOC.4.64.0805282056290.15441@math.ut.ee>
References: <Pine.SOC.4.64.0805272022260.869@math.ut.ee>
 <20080528005346.GK20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ERROR: "copy_page" [fs/fuse/fuse.ko] undefined!
> > ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!
> 
> Try that patch at: http://patchwork.ozlabs.org/linuxppc/patch?id=18710
> 
> Fixes it for me.

Yes, this fixes it, thanks! Hopefully it is merged before 2.6.26.

-- 
Meelis Roos (mroos@linux.ee)
