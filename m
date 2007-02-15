Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXBOTys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXBOTys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161119AbXBOTys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:54:48 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:23366 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120AbXBOTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:54:47 -0500
In-Reply-To: <adazm7fs3qb.fsf@cisco.com>
Subject: Re: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by	wait_for_completion()
To: Roland Dreier <rdreier@cisco.com>
Cc: bos@patchscale.com, Christoph Raisch <raisch@de.ibm.com>,
       hch@infradead.org, heicars2@linux.vnet.ibm.com,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linuxppc-dev-bounces+hnguyen=de.ibm.com@ozlabs.org,
       openib-general@openib.org
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFAA6668FF.C2E1DD58-ONC1257283.006C7A81-C1257283.006D6172@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Thu, 15 Feb 2007 20:54:43 +0100
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 6.5.5HF882 | September 26, 2006) at
 15/02/2007 20:54:44
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> So I'm holding off on applying this for now.  Please think it over and
> either tell me the current patch is OK, or fix it up.  There's not
> really too much urgency because a change like this is something I
> would be comfortable merging between 2.6.21-rc1 and -rc2.
You're absolutely right. Let's target for rc2.
Thanks for this good catch!
Nam

