Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXBUFUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXBUFUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 00:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXBUFUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 00:20:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38081 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXBUFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 00:20:34 -0500
Date: Wed, 21 Feb 2007 00:19:18 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-ID: <20070221051918.GA1722@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000810.GK13958@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000810.GK13958@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For the time being, I included it in unionfs.git. I wouldn't mind having
this dependency disappear.

Thanks,

Josef "Jeff" Sipek.

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
