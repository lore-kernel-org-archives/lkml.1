Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbXKNCLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbXKNCLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbXKNCGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:06:34 -0500
Received: from simq3.bellnexxia.net ([206.47.199.153]:42834 "EHLO
	simq3-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762540AbXKNCGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:06:33 -0500
X-Greylist: delayed 6353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 21:06:33 EST
From: Kevin Winchester <kjwinchester@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded
Date: Tue, 13 Nov 2007 20:20:32 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
In-Reply-To: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711132020.33124.kjwinchester@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On November 13, 2007 08:15:41 am akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
>
>   
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-13-
>04-14.tar.gz
>
> It contains the following patches against 2.6.24-rc2:
>

<snip>

How exactly do I go about trying out this snapshot?  I did the following:

- exported 2.6.24-rc2 from my cloned git tree to a separate folder
- installed quilt
- extracted the patches to the "patches" directory at the top level of the 
2.6.24-rc2 tree
- copied the list of patches from your mail into a "series" file which I 
placed in the "patches" directory
- ran "quilt push -a"

The result was that all of the patches seem to have been applied, but there 
were many offsets and at least one fuzzed patch.  Should they have applied 
cleanly?  Is quilt the way I am supposed to be applying these patches?  Is 
there a reason that there is no "series" file in the archive with the 
patches?

Slightly confused,

-- 
Kevin Winchester
