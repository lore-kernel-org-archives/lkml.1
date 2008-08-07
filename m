Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYHGNEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYHGNEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYHGNED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:04:03 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:53582 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYHGNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:04:01 -0400
Subject: Re: [PATCH 1/1] allocate structures for reservation tracking in
	hugetlbfs outside of spinlocks
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1218049425-19416-1-git-send-email-apw@shadowen.org>
References: <1218033802.7764.31.camel@ubuntu>
	 <1218049425-19416-1-git-send-email-apw@shadowen.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 13:35:54 +0200
Message-Id: <1218108954.4662.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 20:03 +0100, Andy Whitcroft wrote:
> [Gerald, could you see if this works for you it seems to for us on
> an x86 build.  If it does we can push it up to Andrew.]

Yes, it works fine with your patch.

Thanks,
Gerald


