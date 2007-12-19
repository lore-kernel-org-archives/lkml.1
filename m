Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbXLSAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbXLSAlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXLSAli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:41:38 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41683 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753431AbXLSAli (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:41:38 -0500
Date: Wed, 19 Dec 2007 11:41:26 +1100
From: David Chinner <dgc@sgi.com>
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc6
Message-ID: <20071219004126.GS4396912@sgi.com>
References: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:59:11PM +1100, Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Linus, please don't pull this yet. A problem has been found in
the dirent fix, and we've just fixed another mknod related regression
so we've got another couple of fixes still to go in XFS for 2.6.24.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
