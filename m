Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926Ab0AVTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab0AVTdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624Ab0AVTdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:33:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1431 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0AVTdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:33:15 -0500
Subject: Re: [PATCH] get_maintainer.pl: teach git log to use --no-color
From: Joe Perches <joe@perches.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264163484.2143.13.camel@localhost>
References: <1264163484.2143.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 11:33:13 -0800
Message-ID: <1264188793.32383.120.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 12:31 +0000, Richard Kennedy wrote:
> When git has been set to always use color in .gitconfig then I get the
> warning message
> 
>     	Bad divisor in main::vcs_assign: 0
>     
> This is caused by vcs_file_signoffs not matching any commits due to the
> pattern not understand the colour codes. Fix this by telling git log to
> never use colour.
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Thanks.

Acked-by: Joe Perches <joe@perches.com>


