Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYCLCq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYCLCq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYCLCqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:46:49 -0400
Received: from kumera.dghda.com ([80.68.90.171]:2121 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYCLCqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:46:48 -0400
From: "Duane Griffin" <duaneg@dghda.com>
Date: Wed, 12 Mar 2008 02:46:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org, tytso@mit.edu,
       sct@redhat.com, adilger@clusterfs.com
Subject: Re: jbd/2: eliminate code duplication and gracefully handle cache
	initialisation failure
Message-ID: <20080312024644.GA3567@dastardly.plus.com>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com> <20080310124628.44a62466.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310124628.44a62466.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 12:46:28PM -0700, Andrew Morton wrote:
> > This is version 2 of the jdb/2 patches to eliminate code duplication and
> > gracefully handle cace initialisation failure.
> > 
> 
> I couldn't get these to apply and I didn't understand the relationship
> between these new patches and your earlier
> jbd[2]-replace-potentially-false-assertion-with-if-block.patch and
> jbd[2]-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
> so I just dropped everything.
> 
> Please redo and resend against next -mm or
> http://userweb.kernel.org/~akpm/mmotm/, thanks.

Will do, sorry for the inconvenience.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
