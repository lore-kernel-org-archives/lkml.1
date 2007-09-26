Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbXIZPZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbXIZPZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbXIZPYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:24:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46615 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbXIZPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:24:49 -0400
Date: Wed, 26 Sep 2007 08:19:23 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/4] sysfs: misc updates
Message-ID: <20070926151923.GC10460@kroah.com>
References: <11902719091692-git-send-email-htejun@gmail.com> <20070926130424.4579e70e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926130424.4579e70e@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 01:04:24PM +0200, Cornelia Huck wrote:
> On Thu, 20 Sep 2007 16:05:09 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> >  0001-sysfs-kill-SYSFS_FLAG_REMOVED.patch
> >  0002-sysfs-fix-comments-of-sysfs_add-remove_one.patch
> >  0003-sysfs-fix-sysfs_chmod_file-such-that-it-updates-s.patch
> >  0004-sysfs-clean-up-header-files.patch
> >  0005-sysfs-kill-sysfs_update_file.patch
> >  0006-sysfs-reposition-sysfs_dirent-s_mode.patch
> >  0007-sysfs-kill-unnecessary-sysfs_get-in-open-paths.patch
> >  0008-sysfs-kill-unnecessary-NULL-pointer-check-in-sysfs_.patch
> >  0009-sysfs-make-bin-attr-open-get-active-reference-of-pa.patch
> >  0010-sysfs-make-s_elem-an-anonymous-union.patch
> >  0011-sysfs-open-code-sysfs_attach_dentry.patch
> >  0012-sysfs-make-sysfs_root-a-regular-directory-dirent.patch
> >  0013-sysfs-move-sysfs_dirent-s_children-into-sysfs_dire.patch
> >  0014-sysfs-implement-sysfs_open_dirent.patch
> >  0015-sysfs-move-sysfs-file-poll-implementation-to-sysfs_.patch
> 
> OK, I finally found some time for these patches.
> 
> I did my usual attach/detach etc. testing on s390 and didn't run into
> problems. The patches look sane to me as well, so feel free to add
> 
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Thanks for testing, I've added this to the patches in my tree now.

> (or Reviewed-by:, if that's the line-du-jour) to the patches from this
> set.

I don't think we ever came up with a conclusion about this, so I'll
stick with the Acked-by: for now.

thanks again,

greg k-h
