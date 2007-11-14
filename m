Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXKNQlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXKNQlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761015AbXKNQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:40:49 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46478 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760841AbXKNQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:40:48 -0500
Date: Wed, 14 Nov 2007 17:40:38 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: 2.6.24-rc2-mm1
In-Reply-To: <20071114083906.178232cb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
 <20071114083906.178232cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Andrew Morton wrote:

> I'd suspect the driver tree.  I think I'll need to do a quick -mm2 
> without that tree present.

I am just verifying whether reverting kset changes fixes this, will let 
you know soon.

-- 
Jiri Kosina
