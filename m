Return-Path: <linux-kernel-owner+w=401wt.eu-S935050AbXHAPU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935050AbXHAPU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763606AbXHAPUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:20:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34092 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763427AbXHAPUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:20:09 -0400
Date: Wed, 1 Aug 2007 09:20:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
Message-ID: <20070801152007.GA21219@parisc-linux.org>
References: <46B0A3FB.2080701@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B0A3FB.2080701@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 05:17:15PM +0200, Michal Piotrowski wrote:
> -#include<linux/stat.h>
> +#include <linux/stat.h>

Why does this driver need stat.h at all?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
