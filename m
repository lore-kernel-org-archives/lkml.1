Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbXITTTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbXITTTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXITTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:18:56 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35892 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXITTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:18:55 -0400
Date: Thu, 20 Sep 2007 21:19:44 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increase AT_VECTOR_SIZE to terminate saved_auxv properly
Message-ID: <20070920191944.GA14348@aepfle.de>
References: <20070914110057.GA10088@aepfle.de> <20070918115504.GA609@aepfle.de> <20070919234411.d5bf33ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070919234411.d5bf33ea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, Andrew Morton wrote:

> I'm not very confident that this will work well with the
> already-queued move-mm_struct-and-vm_area_struct.patch.

You want me to redo my patch agains the current -mm kernel?
