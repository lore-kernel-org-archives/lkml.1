Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYLKUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYLKUXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYLKUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:23:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845AbYLKUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:23:17 -0500
Date: Thu, 11 Dec 2008 12:22:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Karsten Keil <kkeil@suse.de>
Cc: hannes@hanneseder.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/9] mISDN: fix sparse warnings
Message-Id: <20081211122245.754e7829.akpm@linux-foundation.org>
In-Reply-To: <20081210173056.GB15810@pingi.kke.suse.de>
References: <493feaa6.05a0660a.4b69.407f@mx.google.com>
	<20081210173056.GB15810@pingi.kke.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 18:30:56 +0100
Karsten Keil <kkeil@suse.de> wrote:

> On Tue, Dec 09, 2008 at 08:49:30PM +0100, Hannes Eder wrote:
> > This series of patches fixes a fair amount of sparse warnings in mISDN.
> > 
> 
> Acked-by: Karsten keil <kkeil@suse.de>
> 
> to all.
> 

I was going to apply these but

a) It's nine patches all with the same title and I can't be bothered
   thinking up useful titles for each one.  See
   Documentation/SubmittingPatches

b) I can't find all the patches on lkml.

c) Why am I applying misdn patches anyway?  If someone else already
   applied them then they aren't in linux-next.

