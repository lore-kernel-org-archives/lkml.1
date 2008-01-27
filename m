Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYA0LwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYA0LwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYA0Lvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:51:54 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:54251 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYA0Lvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:51:53 -0500
Date: Sun, 27 Jan 2008 12:52:32 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef linux/vt.h
Message-ID: <20080127115232.GA5373@aepfle.de>
References: <20080125180215.GA30039@aepfle.de> <20080126202010.GA28444@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080126202010.GA28444@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, Christoph Hellwig wrote:

> On Fri, Jan 25, 2008 at 07:02:15PM +0100, Olaf Hering wrote:
> > 
> > remove the newly added __KERNEL__ block from linux/vt.h
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> We shouldn't add more unifdef-y headers.  Please move the newly-added
> kernel-only section to a different file instead and beat up the person
> who introduced it with a big cluestick.

Suggest a place, please.

Also, I think every header should go throug unifdef.
