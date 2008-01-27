Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYA0GES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYA0GES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbYA0GDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:03:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbYA0GDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:03:13 -0500
Date: Sat, 26 Jan 2008 22:02:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: gin@mo.msk.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement dmode option for isofs
Message-Id: <20080126220210.196e679a.akpm@linux-foundation.org>
In-Reply-To: <20080123184752.GE23304@atrey.karlin.mff.cuni.cz>
References: <518x2n9jgn.fsf@mo.msk.ru>
	<20080123184752.GE23304@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Jan 2008 19:47:52 +0100 Jan Kara <jack@suse.cz> wrote:
> Implement dmode option for iso9660 filesystem to allow setting of access
> rights for directories on the filesystem.

Please update Documentation/filesystems/isofs.txt?

Also, the usual form for the description of this patch would be

	isofs: implement dmode option

ie: identify the subsystem first.

Minor point, but it saves me having to rename patches all the time, and
avoids potential confusion.
