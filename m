Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbYBMW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbYBMW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYBMW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:26:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYBMW0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:26:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: uml compile error
Date: Wed, 13 Feb 2008 23:24:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Miklos Szeredi <mszeredi@suse.cz>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20080208223228.GD6505@cs181133002.pp.htv.fi>
In-Reply-To: <20080208223228.GD6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802132324.32114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 8 of February 2008, Adrian Bunk wrote:
> Commit dd2cc4dff3b08ab54c4c177a080046bcc84ac41d broke uml:
> 
> <-- snip  -->
> 
> ...
>   CC      fs/hostfs/hostfs_kern.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function ‘hostfs_show_options’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type
> make[3]: *** [fs/hostfs/hostfs_kern.o] Error 1
> 
> <--  snip  -->

Has it been fixed in the mainline?

Rafael
