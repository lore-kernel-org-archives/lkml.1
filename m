Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbYAPXX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbYAPXX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYAPXRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:17:10 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2666 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbYAPXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:17:07 -0500
Date: Wed, 16 Jan 2008 23:17:04 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <ak@suse.de>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file mode; add warning; add --file-force
Message-ID: <20080116231704.GE24409@shadowen.org>
References: <20080116222121.GA7185@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116222121.GA7185@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:21:21PM +0100, Andi Kleen wrote:
> 
> I'm not entirely sure who collects checkpatch patches for .25 -- i thought it
> was Andy W., but he doesn't seem to answer. Anyways whoever does it please
> queue this patch for the next checkpatch.pl update. Or perhaps it could
> be put into -mm?

It is me, I have been off on holiday skiing.  I have a whole bunch of
updates merged already which I will send out tommorrow.  Your --file is
in the next batch which should be tested and ready by next week.

Sorry for the delay.

-apw
