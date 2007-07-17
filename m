Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXGQI5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXGQI5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXGQI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:57:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbXGQI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:56:59 -0400
Date: Tue, 17 Jul 2007 01:55:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: unprivileged mounts (was: Re: -mm merge plans for 2.6.23)
Message-Id: <20070717015536.7b861bd4.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 01:31:52 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> unprivileged-mounts-add-user-mounts-to-the-kernel.patch
> unprivileged-mounts-allow-unprivileged-umount.patch
> unprivileged-mounts-account-user-mounts.patch
> unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
> unprivileged-mounts-allow-unprivileged-bind-mounts.patch
> unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
> unprivileged-mounts-allow-unprivileged-mounts.patch
> unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
> unprivileged-mounts-propagation-inherit-owner-from-parent.patch
> unprivileged-mounts-add-no-submounts-flag.patch
> 
>  Don't know.  Need to ping suitable developers over this work.

ping.
