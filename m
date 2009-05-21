Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZEUIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZEUIoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZEUIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:44:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZEUIoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:44:02 -0400
Date: Thu, 21 May 2009 10:44:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       jack@suse.cz, trivial@kernel.org
Subject: Re: [PATCH 1/4] Fix minor typos in jbd2's journal.c
In-Reply-To: <1242846091-1086-1-git-send-email-albertito@blitiri.com.ar>
Message-ID: <alpine.LNX.2.00.0905211043100.13917@wotan.suse.de>
References: <1242846091-1086-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Alberto Bertogli wrote:

> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> ---
>  fs/jbd2/journal.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 5814410..85af8ea 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1781,7 +1781,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
>   * Journal abort has very specific semantics, which we describe
>   * for journal abort.
>   *
> - * Two internal function, which provide abort to te jbd layer
> + * Two internal function, which provide abort to the jbd layer

function*s*, while you are at it?

-- 
Jiri Kosina
SUSE Labs
