Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYKWVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYKWVh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYKWVhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:37:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYKWVhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:37:12 -0500
Date: Sun, 23 Nov 2008 22:36:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] fix comment style on mangle_path
Message-ID: <20081123213654.GA16613@elte.hu>
References: <4929C5C8.7090008@oracle.com> <1227475493-5429-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227475493-5429-1-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> Signed-off-by: Török Edwin <edwintorok@gmail.com>
> ---
>  fs/seq_file.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index f5b61cc..f03220d 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -358,10 +358,10 @@ int seq_printf(struct seq_file *m, const char *f, ...)
>  EXPORT_SYMBOL(seq_printf);
>  
>  /**
> - * 	mangle_path - mangle and copy path to buffer beginning
> - * 	@s - buffer start
> - * 	@p - beginning of path in above buffer
> - *      @esc - set of characters that need escaping
> + *	mangle_path -	mangle and copy path to buffer beginning
> + *	@s: buffer start
> + *	@p: beginning of path in above buffer
> + *	@esc: set of characters that need escaping

thanks - applied this too.

	Ingo
