Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZG1SM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZG1SM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZG1SM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:12:27 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58078 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbZG1SM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:12:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Tue, 28 Jul 2009 12:11:51 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0/2] implement uid mount option for ext2 and ext3, try 3
In-reply-to: <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090728181151.GZ4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 28, 2009  13:01 +0200, Ludwig Nussel wrote:
> As suggested by  Andreas Dilger, map _all_ files to the specified
> uid and also store the specified uid on disk instead of using root.
> Optionally the uid used on disk can be specified.
> 
> Additionally the gid can be changed too now in the same way as the
> uid.

Looks good, you can add:
Acked-by: Andreas Dilger <adilger@sun.com>

Please also submit the same patch for ext4.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

