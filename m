Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0BHSMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:12:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47532 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:12:46 -0500
Date: Mon, 8 Feb 2010 19:12:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 15/16] PM: remove trailing space in message
Message-ID: <20100208181237.GC1469@ucw.cz>
References: <201002061844.45212.elendil@planet.nl> <1265478443-31072-15-git-send-email-elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265478443-31072-15-git-send-email-elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-02-06 18:47:22, Frans Pop wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: linux-pm@lists.linux-foundation.org
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

ack.

> +++ b/kernel/power/snapshot.c
> @@ -1500,7 +1500,7 @@ asmlinkage int swsusp_save(void)
>  {
>  	unsigned int nr_pages, nr_highmem;
>  
> -	printk(KERN_INFO "PM: Creating hibernation image: \n");
> +	printk(KERN_INFO "PM: Creating hibernation image:\n");
>  
>  	drain_local_pages(NULL);
>  	nr_pages = count_data_pages();

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
