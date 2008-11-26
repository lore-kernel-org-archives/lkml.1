Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYKZIbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYKZIbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYKZIbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:31:21 -0500
Received: from corega.com.ru ([195.178.208.66]:43636 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYKZIbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:31:20 -0500
Date: Wed, 26 Nov 2008 11:31:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [resend take 3 0/4] Distributed storage.
Message-ID: <20081126083118.GA21558@ioremap.net>
References: <12276238703113-git-send-email-zbr@ioremap.net> <20081125234707.GG5324@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125234707.GG5324@gambetta>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederik.

On Wed, Nov 26, 2008 at 12:47:07AM +0100, Frederik Deweerdt (frederik.deweerdt@xprog.eu) wrote:
> The attached patch is needed to compile against 2.6.28-rc6 (changes in
> block_devices_operations), I added a few cleanups as well.

I will queue it for inclusion, when will rebase against latest tree.
Patches are against stable tree, so this may make some confusion.

Thank you.

-- 
	Evgeniy Polyakov
