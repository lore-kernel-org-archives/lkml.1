Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZFHTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZFHTmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZFHTmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:42:37 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2320 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZFHTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:42:36 -0400
Date: Mon, 8 Jun 2009 16:41:12 -0300
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 43/49] jbd2: Fix minor typos in comments in
	fs/jbd2/journal.c
Message-ID: <20090608194112.GB4852@blitiri.com.ar>
References: <1244488987-32564-35-git-send-email-tytso@mit.edu> <1244488987-32564-36-git-send-email-tytso@mit.edu> <1244488987-32564-37-git-send-email-tytso@mit.edu> <1244488987-32564-38-git-send-email-tytso@mit.edu> <1244488987-32564-39-git-send-email-tytso@mit.edu> <1244488987-32564-40-git-send-email-tytso@mit.edu> <1244488987-32564-41-git-send-email-tytso@mit.edu> <1244488987-32564-42-git-send-email-tytso@mit.edu> <1244488987-32564-43-git-send-email-tytso@mit.edu> <1244488987-32564-44-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244488987-32564-44-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.17 (2008-03-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:23:01PM -0400, Theodore Ts'o wrote:
> From: Alberto Bertogli <albertito@blitiri.com.ar>
> 
> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
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
>   * itself are here.
>   */

There is a second version of the patch (the one you replied to) that has
"function*s*" fixed.

Message ID was 1242913187-4151-1-git-send-email-albertito@blitiri.com.ar. If
you want me to resend it, let me know.

Thanks,
		Alberto

