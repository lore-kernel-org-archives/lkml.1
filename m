Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbXEXRVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbXEXRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXEXRVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:21:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22076 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXEXRVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qvoWRd1n59zLgVmJKSSwhJJIhQrHlLiFBgJ79ULApfCBl8qVjrR05j0DBTg4lzMdy0j0DwWEBWR0OjgXZeryE4mDPt/tx99aNNmnJ6fwWOruYZqfdFnyuCe+5dxO/gCt7qes33ErCoy93jKlwlgzLIuPiF9c4JpRcAnSWkPHWis=
Date: Thu, 24 May 2007 21:20:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Fix possible UDF data corruption
Message-ID: <20070524172017.GA19852@cvg>
References: <20070524165935.GB19709@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524165935.GB19709@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Thu, May 24, 2007 at 06:59:35PM +0200]
|   Hi Andrew,
| 
|   attached patch fixes possible data corruption in UDF - this bug was actually
| introduced by one of my fixes :-( and should (if possible) go to Linus before
| 2.6.22 is out (that's why I'm diffing against Linus's tree and not the
| latest changes in -mm tree)... Thanks.
| 
| 								Honza
| 
| -- 
| Jan Kara <jack@suse.cz>
| SuSE CR Labs

Jan should I wait until Andrew has your patches included and
only then (having taken into account your patches) produce my
conversion?

		Cyrill

