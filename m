Return-Path: <linux-kernel-owner+w=401wt.eu-S1423018AbXCBLEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbXCBLEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXCBLEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:04:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423018AbXCBLEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:04:09 -0500
Date: Fri, 2 Mar 2007 03:04:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070302030405.22f78999.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 03:00:26 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/

Forget to mention:  there's a huge wireless update in there:

   Changes include the new wireless stack, the associated drivers, and
   the new wireless configuration mechanisms, as well as some b44 changes
   related to hardware in-common with bcm43xx.  There are currently over
   700 individual patches in the entire series.  I have the individual
   patches extracted and available here:

     	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-dev/mm-master

please be sure to cc netdev@vger.kernel.org if anything goes wrong with it.
