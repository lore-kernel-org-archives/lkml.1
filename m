Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbZFEWwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbZFEWwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZFEWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:51:56 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48374 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZFEWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:51:55 -0400
Date: Sat, 6 Jun 2009 00:54:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ignore *.patch files
Message-ID: <20090605225412.GT29008@uranus.ravnborg.org>
References: <1243381074-10488-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243381074-10488-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 07:37:54PM -0400, Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 51bd99d..3433d7c 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -25,6 +25,7 @@
>  *.elf
>  *.bin
>  *.gz
> +*.patch

Applied,
	Sam
