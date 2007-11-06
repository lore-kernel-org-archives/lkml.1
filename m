Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbXKFQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbXKFQrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXKFQrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:47:14 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:19440 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbXKFQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:47:13 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: aglitke <agl@us.ibm.com>
Subject: Re: problem in follow_hugetlb_page on ppc64 architecture with get_user_pages
Date: Tue, 6 Nov 2007 17:39:34 +0100
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <RAISCH@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, general@lists.openfabrics.org,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>
References: <OF6FC435A0.F59C9AD9-ONC125738B.002A5195-C125738B.002A424A@de.ibm.com> <1194361532.20383.4.camel@localhost.localdomain>
In-Reply-To: <1194361532.20383.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711061739.34952.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam!
On Tuesday 06 November 2007 16:05, aglitke wrote:
> Please try this patch and see if it helps.
Tested on 2.6.22 (don't have the system with 2.6.23 at the moment) and
the testcase ran perfectly.
Thanks!
Nam

