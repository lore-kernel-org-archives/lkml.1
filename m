Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0CCJtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:49:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:56560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0CCJtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:49:49 -0500
Date: Wed, 3 Mar 2010 10:49:47 +0100
From: Michal Marek <mmarek@suse.cz>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kbuild - tags
Message-ID: <20100303094947.GB15480@sepie.suse.cz>
References: <1267545472-17131-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267545472-17131-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:57:52PM +0100, John Kacur wrote:
> 	- Add the ability to make tags for all archs using "all"
> 		make ALLSOURCE_ARCHS=all tags
> 	- Document this in kbuild.txt
> 
> 	Without this change you have to type each arch separately.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Thanks, applied.

Michal
