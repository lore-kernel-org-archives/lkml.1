Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYENVyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYENVyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbYENVyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:54:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbYENVyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:54:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc2-mm1
Date: Wed, 14 May 2008 23:54:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805142354.02573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 14 of May 2008, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> 
> 
> - The -mm tree is now based on linux-next.
> 
>   I will occasionally pick up later versions of trees which are already
>   in linux-next, to catch material which was added after Stephen last
>   pulled that tree.  That happened this time: git-net had a lot of driver
>   changes which weren't in linux-next and which I wanted in
>   2.6.26-rc2-mm1.
> 
> - A few more git trees were added: git-ubifs.patch, git-regulator.patch,
>   git-logfs.patch, git-orion.patch.

My HP nx6325 doesn't resume from suspend.  It looks like the graphics doesn't
come up, so probably s2ram is busted.

I'll try to bisect on weekend, if I have the time (not sure).

Thanks,
Rafael
