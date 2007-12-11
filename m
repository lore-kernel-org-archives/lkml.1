Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXLKOzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXLKOzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXLKOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:55:28 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:42207 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785AbXLKOz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:55:27 -0500
Date: Tue, 11 Dec 2007 20:24:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       kay.sievers@vrfy.org, gregkh@suse.de
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071211145437.GA15617@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca> <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210091501.deed38fa.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 09:15:01AM -0800, Randy Dunlap wrote:
> On Mon, 10 Dec 2007 09:03:17 -0500 Fortier,Vincent [Montreal] wrote:
> 
> Ingo, can you look at this, please?
> Vincent is getting oopses on 2.6.22.14-cfs-etch.
> 

Hi,

We are looking into this bug now. I believe that the patch at
http://marc.info/?l=linux-kernel&m=119404922603293 should help.

I am working with Kay to get this ported.

Thanks,
-- 
regards,
Dhaval
