Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZFAIuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZFAIuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZFAIuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:50:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZFAIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:50:03 -0400
Date: Mon, 1 Jun 2009 10:50:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: GeunSik Lim <leemgs1@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace:fix description of trace directory
In-Reply-To: <1243813869.20635.34.camel@centos51>
Message-ID: <alpine.LNX.2.00.0906011049450.11359@wotan.suse.de>
References: <1243813869.20635.34.camel@centos51>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, GeunSik Lim wrote:

> ---
>  Documentation/trace/ftrace.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index fd9a3e6..608770c 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -1825,4 +1825,4 @@ an error.
>  -----------
>  
>  More details can be found in the source code, in the
> -kernel/tracing/*.c files.
> +kernel/trace/*.c files.

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs
