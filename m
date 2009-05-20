Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZETPpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZETPpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZETPpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:45:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:53317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbZETPpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:45:12 -0400
Date: Wed, 20 May 2009 08:37:18 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/20] Sysfs cleanups
Message-ID: <20090520153718.GB26111@suse.de>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bppofm9k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:09:43PM -0700, Eric W. Biederman wrote:
> 
> The following patch series cleans up sysfs to the point where itq is
> generally a good citizen of the vfs layer.  The big theme is lazy
> synchronization from the sysfs data structures to the vfs data
> structures using the same techniques as most other distributed
> filesystems.

Hm, I only seem to have gotten patch 0/20, none of the actual patches.
Did I somehow miss them?

confused,

greg k-h
