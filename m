Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZL2Sur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZL2Sur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZL2Suq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:50:46 -0500
Received: from dhael.aehallh.com ([63.254.233.42]:60154 "EHLO
	dhael.aehallh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZL2Suq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:50:46 -0500
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 13:50:45 EST
Date: Tue, 29 Dec 2009 13:42:20 -0500
From: "Zephaniah E. Hull" <warp-spam_kernel@aehallh.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zephaniah E. Hull" <warp-spam_kernel@aehallh.com>
Subject: Re: [Bug #14862] intel-agp breaks X, regression from 2.6.31
Message-ID: <20091229184220.GO19249@aehallh.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <srmJ8vMxKPH.A.ujC.cwhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <srmJ8vMxKPH.A.ujC.cwhOLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:28:51PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14862
> Subject		: intel-agp breaks X, regression from 2.6.31
> Submitter	: Zephaniah E. Hull. <warp-spam_kernel@aehallh.com>
> Date		: 2009-12-22 22:59 (8 days old)

I plan on testing 2.6.32.2 later today in hopes that some of the IOMMU
changes will have done something in regards to this.
