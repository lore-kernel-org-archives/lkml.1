Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZAJQ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZAJQ1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 11:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZAJQ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 11:27:31 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:35848 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZAJQ1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 11:27:30 -0500
Message-ID: <4968CCC1.1070106@gmail.com>
Date: Sat, 10 Jan 2009 19:28:49 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Reiserfs mailing list <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: Jeff Mahoney <jeffm@suse.com>
Subject: Reiserfsprogs-3.6.21
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

This contains the following changes since reiserfsprogs-3.6.19:

    Patches from Jeff Mahoney:
    - reiserfsprogs-mkreiserfs-quiet.diff
    - reiserfsprogs-large-block-warning.diff
    - reiserfsprogs-fsck-mapid.diff
    - reiserfsprogs-external-journal-changes.diff
    - reiserfsprogs-remove-stupid-fsck_sleep.diff
    - reiserfsprogs-mkfs-use-o_excl.diff
    - reiserfsprogs-enforce-block-limit.diff
    - reiserfsprogs-large-fs.diff
    - reiserfsprogs-better-fsck-a-behavior.diff
    - reiserfsprogs-remove-dependency-on-asm_unaligned.h.diff
    - reiserfsprogs-progress.diff
    - reiserfsprogs-reorder-libs.diff

    Patches from Ludwig Nussel:
    -
mkreiserfs-set-the-owner-of-the-root-directory-to-the-calling-user.diff

    Patches from Edward Shishkin:
    - reiserfsprogs-disable-small-block.diff
    - reiserfsprogs-new-version.diff

All the patches had been announced at reiserfs-devel mailing
list , and the stuff got testing as a part of latest SuSE distros.

Please, find at http://www.kernel.org/pub/linux/utils/fs/reiserfs

Thanks,
Edward.
