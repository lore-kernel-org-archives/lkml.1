Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXIZBDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXIZBDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXIZBDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:03:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53635 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXIZBDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:03:40 -0400
Date: Tue, 25 Sep 2007 21:02:43 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: randy.dunlap@oracle.com, akpm@linux-foundation.org,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org,
       ezk@cs.sunysb.edu
Subject: Re: [PATCH 1/1] Unionfs: move poison #define into poison.h
Message-ID: <20070926010243.GG352@filer.fsl.cs.sunysb.edu>
References: <20070925102637.79e1dc75.randy.dunlap@oracle.com> <1190742319943-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190742319943-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 01:45:19PM -0400, Josef 'Jeff' Sipek wrote:
> This also fixes a compile warning on 64-bit systems.
 
Ok, I had a brain-fart...ignore this patch.

Jeff.

-- 
We have joy, we have fun, we have Linux on a Sun...
