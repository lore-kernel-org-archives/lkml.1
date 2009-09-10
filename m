Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZIJIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZIJIWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZIJIWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:22:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:54468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbZIJIWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:22:30 -0400
Date: Thu, 10 Sep 2009 10:22:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Fixed typo
In-Reply-To: <1252562541-32609-1-git-send-email-sojkam1@fel.cvut.cz>
Message-ID: <alpine.LNX.2.00.0909101022140.23856@wotan.suse.de>
References: <1252562541-32609-1-git-send-email-sojkam1@fel.cvut.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, Michal Sojka wrote:

> Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
> ---
>  Documentation/trace/events.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
> index f157d75..8efb969 100644
> --- a/Documentation/trace/events.txt
> +++ b/Documentation/trace/events.txt
> @@ -72,7 +72,7 @@ To enable all events in sched subsystem:
>  
>  	# echo 1 > /debug/tracing/events/sched/enable
>  
> -To eanble all events:
> +To enable all events:
>  
>  	# echo 1 > /debug/tracing/events/enable

Applied to trivial queue, thanks Michal.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
