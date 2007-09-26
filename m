Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbXIZLFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbXIZLFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXIZLFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:05:00 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:58390 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbXIZLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:04:59 -0400
Date: Wed, 26 Sep 2007 13:04:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/4] sysfs: misc updates
Message-ID: <20070926130424.4579e70e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
References: <11902719091692-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 16:05:09 +0900,
Tejun Heo <htejun@gmail.com> wrote:

>  0001-sysfs-kill-SYSFS_FLAG_REMOVED.patch
>  0002-sysfs-fix-comments-of-sysfs_add-remove_one.patch
>  0003-sysfs-fix-sysfs_chmod_file-such-that-it-updates-s.patch
>  0004-sysfs-clean-up-header-files.patch
>  0005-sysfs-kill-sysfs_update_file.patch
>  0006-sysfs-reposition-sysfs_dirent-s_mode.patch
>  0007-sysfs-kill-unnecessary-sysfs_get-in-open-paths.patch
>  0008-sysfs-kill-unnecessary-NULL-pointer-check-in-sysfs_.patch
>  0009-sysfs-make-bin-attr-open-get-active-reference-of-pa.patch
>  0010-sysfs-make-s_elem-an-anonymous-union.patch
>  0011-sysfs-open-code-sysfs_attach_dentry.patch
>  0012-sysfs-make-sysfs_root-a-regular-directory-dirent.patch
>  0013-sysfs-move-sysfs_dirent-s_children-into-sysfs_dire.patch
>  0014-sysfs-implement-sysfs_open_dirent.patch
>  0015-sysfs-move-sysfs-file-poll-implementation-to-sysfs_.patch

OK, I finally found some time for these patches.

I did my usual attach/detach etc. testing on s390 and didn't run into
problems. The patches look sane to me as well, so feel free to add

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

(or Reviewed-by:, if that's the line-du-jour) to the patches from this
set.
