Return-Path: <linux-kernel-owner+w=401wt.eu-S964864AbXLQUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbXLQUMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765461AbXLQTtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:49:35 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:21167 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934862AbXLQTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mZJkpGVtzJCsYWgiJvZ2G7Xi5Hr6ENoci8P6MOzEoT8/NQXuH097PpG0HH6n4Ox43zwttTypT9o9v/wR8cD1+sj745ZuZgsgMYmrysb1Ml99/1y5GWYq787w9W15VezjQKOfv9eqSMz1ipcdKhcMj5+IcUOcUC7HfAXjHX0T3cA=
Message-ID: <8bd0f97a0712171149n219d4b07pea3da3d68af98b58@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:49:31 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] arch/blackfin/: Spelling fixes
Cc: linux-kernel@vger.kernel.org,
       "Blackfin Architecture Team" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1197919875-5288-4-git-send-email-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197919875-5288-4-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 2:30 PM, Joe Perches <joe@perches.com> wrote:
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/blackfin/kernel/early_printk.c      |    2 +-
>  arch/blackfin/mach-bf548/ints-priority.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

thanks, this has been merged into the Blackfin tree and will get
pushed by Bryan during the next set
-mike
