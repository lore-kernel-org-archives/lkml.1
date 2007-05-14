Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbXENURc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbXENURc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXENURK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:17:10 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:35369 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbXENURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:17:08 -0400
Date: Mon, 14 May 2007 14:17:06 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
Message-ID: <20070514201706.GD5286@schatzie.adilger.int>
Mail-Followup-To: Bharata B Rao <bharata@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Blunck <j.blunck@tu-harburg.de>, Theodore Ts'o <tytso@mit.edu>
References: <20070514093722.GB4139@in.ibm.com> <20070514094450.GO4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514094450.GO4139@in.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14, 2007  15:14 +0530, Bharata B Rao wrote:
>  #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
>  #define EXT3_FEATURE_INCOMPAT_META_BG		0x0010
> +#define EXT3_FEATURE_INCOMPAT_WHITEOUT		0x0020

Is this flag reserved with Ted?  It isn't listed in the e2fsprogs repo.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

