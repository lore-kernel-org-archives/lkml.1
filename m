Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZJQVHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZJQVHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZJQVHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:07:33 -0400
Received: from kroah.org ([198.145.64.141]:36512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZJQVHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:07:33 -0400
Date: Sat, 17 Oct 2009 14:07:23 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <ben@decadent.org.uk>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/get_maintainer.pl: Add --roles and
	--rolestats
Message-ID: <20091017210723.GC5926@kroah.com>
References: <6a3d8d2c4775189d3f854bdd25a87b0d2e37987e.1255811956.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a3d8d2c4775189d3f854bdd25a87b0d2e37987e.1255811956.git.joe@perches.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 01:47:20PM -0700, Joe Perches wrote:
> --roles shows the role of each email address, i.e. why it was selected.
> --rolestats selects --roles and adds git log/blame signers #'s and %
> 
> Multiple roles are possible (supporter, maintainer, git-signer...)
> 
> --roles or --rolestats is meant to help identify appropriate maintainers
> to notify and should not be used with "git send-email --cc-cmd"

Very cool stuff, nice job.

greg k-h
