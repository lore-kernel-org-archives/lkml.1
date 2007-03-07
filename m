Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXCGImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXCGImX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCGImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:42:23 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39335 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161323AbXCGImW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:42:22 -0500
Date: Wed, 7 Mar 2007 09:39:48 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2
Message-ID: <20070307093948.188ac51c@frecb000686.frec.bull.fr>
In-Reply-To: <20070306004408.d3f6434d.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 09:44:04,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 09:44:05,
	Serialize complete at 07/03/2007 09:44:05
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Andrew,

On Tue, 6 Mar 2007 00:44:08 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm2/
> 
> 
> - git-block.patch is having problems which are getting in the way - it has
>   been dropped.
> 
> - As a consequence all the AIO patches were dropped
> 

  Why? The aio notification and listio patches have nothing to do with
git-block.patch.

  If you think those patches will be rendered obsolete by the new
syslet/fibril/whatever approach, then fine. Otherwise do you expect me to
resubmit?

  Thanks,

  Sébastien.
