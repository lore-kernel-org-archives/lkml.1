Return-Path: <linux-kernel-owner+w=401wt.eu-S1765478AbXHYHvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765478AbXHYHvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 03:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXHYHv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 03:51:27 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3224 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbXHYHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 03:51:27 -0400
Date: Sat, 25 Aug 2007 09:51:05 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: Re: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
Message-ID: <20070825075105.GM7029@deprecation.cyrius.com>
References: <20070824160834.GA7029@deprecation.cyrius.com> <1187991182.17399.336.camel@linuxchandra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187991182.17399.336.camel@linuxchandra>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chandra Seetharaman <sekharan@us.ibm.com> [2007-08-24 14:33]:
> It does, but "rdac" _is_ for a SCSI device.
> 
> What device are you using it with ?

I'm not using it at all.  I merely compiled a kernel where
DM_MULTIPATH_RDAC was activated by chance without SCSI.  Randy's patch
looks good.
-- 
Martin Michlmayr
http://www.cyrius.com/
