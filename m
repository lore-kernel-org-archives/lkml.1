Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZAELeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZAELeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZAELeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:34:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50933 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZAELeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:34:22 -0500
Date: Mon, 5 Jan 2009 11:34:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090105113420.GN28946@ZenIV.linux.org.uk>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> kill-suid-bit-only-for-regular-files.patch
> vfs-lseekfd-0-seek_cur-race-condition.patch
> vfs-factor-out-duplicated-code-in-get_fs_type.patch
> inotify-fix-type-errors-in-interfaces.patch

These are in tonight's (oh, fsck - this morning's already) VFS pile.
