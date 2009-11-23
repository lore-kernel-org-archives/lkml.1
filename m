Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZKWJW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZKWJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZKWJW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:22:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:43342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZKWJW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:22:58 -0500
Date: Mon, 23 Nov 2009 10:23:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: lg@opensource.wolfsonmicro.com, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] Trivial, Regulator docs cut-and-pasteism
In-Reply-To: <20091122145314.GA24475@gallifrey>
Message-ID: <alpine.LSU.2.00.0911231022510.6953@wotan.suse.de>
References: <20091122145314.GA24475@gallifrey>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009, Dr. David Alan Gilbert wrote:

> Minor copy-and-pasteism in the regulator docs (against
> git from today):
> 
>   Signed-off-by: Dave Gilbert <linux@treblig.org>
> 
> diff --git a/Documentation/power/regulator/consumer.txt b/Documentation/power/regulator/consumer.txt
> index 5f83fd2..cdebb51 100644
> --- a/Documentation/power/regulator/consumer.txt
> +++ b/Documentation/power/regulator/consumer.txt
> @@ -104,7 +104,7 @@ to set the limit to 500mA when supplying power.
>  
>  Consumers can control their supply current limit by calling :-
>  
> -int regulator_set_current_limit(regulator, min_uV, max_uV);
> +int regulator_set_current_limit(regulator, min_uA, max_uA);

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
