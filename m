Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXHYIFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXHYIFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933634AbXHYIFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:05:05 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2207 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598AbXHYIFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:05:01 -0400
Date: Sat, 25 Aug 2007 10:04:42 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: sekharan@us.ibm.com, Mike Christie <michaelc@cs.wisc.edu>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
Message-ID: <20070825080442.GA25392@deprecation.cyrius.com>
References: <20070824160834.GA7029@deprecation.cyrius.com> <1187991182.17399.336.camel@linuxchandra> <20070824150021.a7fdc9f6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824150021.a7fdc9f6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2007-08-24 15:00]:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> DM_MULTIPATH_RDAC uses SCSI API(s) and is for a SCSI device,
> so add SCSI to its depends on to prevent build errors.
> 
> Not tested.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Tested-by: Martin Michlmayr <tbm@cyrius.com>

This works for me.  Please make sure it'll go into 2.6.23.
-- 
Martin Michlmayr
http://www.cyrius.com/
