Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZFTMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZFTMk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZFTMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 08:40:21 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40158 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZFTMkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 08:40:21 -0400
Date: Sat, 20 Jun 2009 14:42:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gitignore scripts/ihex2fw
Message-ID: <20090620124240.GA692@uranus.ravnborg.org>
References: <1245228117.2662.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245228117.2662.2.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 02:11:57PM +0530, Jaswinder Singh Rajput wrote:
> 
> scripts/ihex2fw is a binary file is suitable candidate for ignore
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  .gitignore |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index cecb3b0..cdfb7ce 100644
> --- a/.gitignore
> +++ b/.gitignore

Why not scripts/.gitignore?

	Sam
