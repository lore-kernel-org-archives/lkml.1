Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZAEJkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZAEJkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAEJkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:40:07 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:35584 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZAEJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hZahHUYubyTxbc6mboo1hO1wxIsOBotvfmhMBqDzu+5rESb2LPWVmkfHHvSuIjOEOH
         3dnRl00M4YQLZ3CY+DDjGWO2jDLYvSdlB+FcsayQB5rbAARryKrHLhFfgTqHm7eEF/2b
         vMVffzp1m/JR4+2fDr8mOJarOhvZHbChLwIfM=
Message-ID: <c4a7c9420901050140u23697729pc55966110d68452b@mail.gmail.com>
Date: Mon, 5 Jan 2009 18:40:04 +0900
From: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090105004300.19ed52d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
X-Google-Sender-Auth: 815caecd82c4a57e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 Andrew Morton <akpm@linux-foundation.org>:
> nilfs2-add-document.patch
> nilfs2-disk-format-and-userland-interface.patch
> nilfs2-add-inode-and-other-major-structures.patch
> nilfs2-integrated-block-mapping.patch
> nilfs2-b-tree-based-block-mapping.patch
> nilfs2-direct-block-mapping.patch
> nilfs2-b-tree-node-cache.patch
> nilfs2-buffer-and-page-operations.patch
> nilfs2-meta-data-file.patch
> nilfs2-persistent-object-allocator.patch
> nilfs2-disk-address-translator.patch
> nilfs2-inode-map-file.patch
> nilfs2-checkpoint-file.patch
> nilfs2-segment-usage-file.patch
> nilfs2-inode-operations.patch
> nilfs2-inode-operations-fix.patch
> nilfs2-file-operations.patch
> nilfs2-directory-entry-operations.patch
> nilfs2-pathname-operations.patch
> nilfs2-pathname-operations-fix.patch
> nilfs2-operations-for-the_nilfs-core-object.patch
> nilfs2-super-block-operations.patch
> nilfs2-super-block-operations-fix.patch
> nilfs2-segment-buffer.patch
> nilfs2-segment-constructor.patch
> nilfs2-recovery-functions.patch
> nilfs2-another-dat-for-garbage-collection.patch
> nilfs2-block-cache-for-garbage-collection.patch
> nilfs2-ioctl-operations.patch
> nilfs2-update-makefile-and-kconfig.patch
> #
> nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
> nilfs2-cleanup-nilfs_clear_inode.patch
> nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
> nilfs2-insert-explanations-in-gcinode-file.patch
> nilfs2-add-maintainer.patch
> nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
>
>  Dunno.   Has this been reviewed enough?
>

I'm now working to follow some comments from Chris, and
I think nilfs should be reviewed more widely.

I'll aim for the next merge window or so.

Ryusuke Konishi
