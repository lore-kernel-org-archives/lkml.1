Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbXF1FbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbXF1FbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 01:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXF1Fa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 01:30:56 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:48085 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbXF1Fay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 01:30:54 -0400
Date: Wed, 27 Jun 2007 18:41:05 -0400
From: Andreas Dilger <adilger@clusterfs.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070627224105.GD5606@schatzie.adilger.int>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org> <20070627151114.GM1094@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627151114.GM1094@stusta.de>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance you can remove linux-fsdevel from the CC list?  I don't think this
has anything to do with filesystems.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

