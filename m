Return-Path: <linux-kernel-owner+w=401wt.eu-S936889AbXHHQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936889AbXHHQeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbXHHQdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:33:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33008 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759775AbXHHQdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:33:51 -0400
Message-ID: <46B9F06A.4000800@pobox.com>
Date: Wed, 08 Aug 2007 12:33:46 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ramkrishna Vepa <Ramkrishna.Vepa@neterion.com>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 68] drivers/net/s2io.c: kmalloc + memset conversion to
 k[cz]alloc
References: <78C9135A3D2ECE4B8162EBDCE82CAD77020354C0@nekter>
In-Reply-To: <78C9135A3D2ECE4B8162EBDCE82CAD77020354C0@nekter>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkrishna Vepa wrote:
> We have a few patches queued and can send this patch in along with ours.

That would be great, thanks.

	Jeff



