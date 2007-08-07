Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbXHGUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbXHGUKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXHGUJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:09:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56607 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXHGUJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:09:58 -0400
Date: Tue, 7 Aug 2007 22:09:48 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove genhd.h from header exports
Message-ID: <20070807200948.GA31378@aepfle.de>
References: <20070807184722.GA31015@aepfle.de> <46B8C18D.7040902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46B8C18D.7040902@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, Jeff Garzik wrote:

> AFAICS the proper fix is to undo the CONFIG_BLOCK breakage, not make the 
> header unusable.

No package uses linux/genhd.h, it is safe to remove it.
