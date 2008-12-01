Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYLAD6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYLAD6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 22:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLAD6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 22:58:04 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:52760 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLAD6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 22:58:03 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [rfc git patch] union directory 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: bharata@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
       dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <20081128161921.GA3843@in.ibm.com> <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
Date: Mon, 01 Dec 2008 12:57:40 +0900
Message-ID: <9507.1228103860@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Miklos,

Miklos Szeredi:
> The plan is to get a simple kernel implementation first which caches
> the directory in 'struct file'.

If you have not looked at the source code of AUFS, try it out.
It caches the directory entries in 'struct file.'

approach: http://marc.info/?l=linux-kernel&m=118915086030712&w=2
dir.[ch]: http://marc.info/?l=linux-kernel&m=121134143206375&w=2
vdir.c: http://marc.info/?l=linux-kernel&m=121134246707486&w=2


J. R. Okajima
