Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab0CMWXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:23:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0CMWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:23:41 -0500
Date: Sat, 13 Mar 2010 23:23:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Markus Rathgeb <rathgeb.markus@googlemail.com>
Cc: zinx@epicsol.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.33] hid-tmff: Add RGT ff clutch device id
In-Reply-To: <201003131729.48645.rathgeb.markus@googlemail.com>
Message-ID: <alpine.LRH.2.00.1003132322340.12517@twin.jikos.cz>
References: <201003131729.48645.rathgeb.markus@googlemail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Markus Rathgeb wrote:

> From: Markus Rathgeb
> 
> This patch enables force feedback for the "RGT Force Feedback CLUTCH Racing Wheel".
> It only modifies hid-core.c (hid_blacklist) and hid-tmff.c to add the new USB IDs.
> 
> Signed-off-by: Markus Rathgeb <rathgeb.markus@googlemail.com>

I have applied the patch. But ...

> --- a/a/drivers/hid/hid-core.c
> +++ b/b/drivers/hid/hid-core.c

... please generate the patches next time in a way that they can be 
applied using "patch -p1" to kernel tree (note the extraneous "a/a").

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

