Return-Path: <linux-kernel-owner+w=401wt.eu-S1764133AbXIKS33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764133AbXIKS33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761857AbXIKS3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:29:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57661 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761226AbXIKS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:29:21 -0400
Date: Tue, 11 Sep 2007 20:29:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070911182926.GQ3563@stusta.de>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 10:16:44AM -0700, Randy Dunlap wrote:
>...
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +Mutt (TUI)
> +
> +Plenty of Linux developers use mutt, so it must work pretty well.
> +
> +Are there any special config options that are needed??
>...

It should work with default settings.

mutt doesn't come with an editor, so whatever editor you use should be 
used in a way that there are no automatic linebreaks. Most editors have 
an "insert file" option that inserts the contents of a file unaltered.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

