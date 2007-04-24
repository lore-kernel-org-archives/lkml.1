Return-Path: <linux-kernel-owner+w=401wt.eu-S1423100AbXDXV01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423100AbXDXV01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423118AbXDXV01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:26:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:12896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423100AbXDXV0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:26:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218920984:sNHT21552762"
Date: Tue, 24 Apr 2007 14:24:33 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 6/8] Doc updates for Intel Virtualization Technology for Directed I/O.
Message-ID: <20070424212433.GA31920@linux-os.sc.intel.com>
References: <20070423163837.447443000@linux.intel.com> <20070423164957.376691000@linux.intel.com> <d9def9db0704241417i2e52aad6p35c5f484c0599550@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0704241417i2e52aad6p35c5f484c0599550@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 11:17:55PM +0200, Markus Rechberger wrote:
> >+We also allocate gaurd pages with each mapping, so we can attempt to catch
> >+any overflow that might happen.
> >+
> 
> guess you probably mean guard tables here...
> 

So there is a good chance i can be "The Governor of California" :-)
