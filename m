Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXHXPr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXHXPr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXHXPrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:47:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47790 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXHXPrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:47:20 -0400
Date: Fri, 24 Aug 2007 08:46:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: andre@finow14.de
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch trivial] fix typo in Documentation/SubmittingPatches
Message-Id: <20070824084651.71a5c592.randy.dunlap@oracle.com>
In-Reply-To: <20070824094513.GA14451@ahaupt-debian-vm.localdomain>
References: <20070824093648.585376833@finow14.de>
	<20070824094513.GA14451@ahaupt-debian-vm.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 11:45:13 +0200 andre@finow14.de wrote:

> From: Andre Haupt <andre@finow14.de>
> Signed-off-by: Andre Haupt <andre@finow14.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> Index: linus/Documentation/SubmittingPatches
> ===================================================================
> --- linus.orig/Documentation/SubmittingPatches	2007-08-24 11:12:33.000000000 +0200
> +++ linus/Documentation/SubmittingPatches	2007-08-24 11:13:51.000000000 +0200
> @@ -126,7 +126,7 @@
>  without even being read.
>  
>  At a minimum you should check your patches with the patch style
> -checker prior to submission (scripts/patchcheck.pl).  You should
> +checker prior to submission (scripts/checkpatch.pl).  You should
>  be able to justify all violations that remain in your patch.
>  
>  
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
