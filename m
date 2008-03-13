Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYCMRuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYCMRuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYCMRuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:50:03 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:38793 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbYCMRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:50:01 -0400
Subject: Re: [patch 09/10] Hugetlb common code update for System z.
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: haveblue@us.ibm.com, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
In-Reply-To: <20080312164303.cac9cab5.akpm@linux-foundation.org>
References: <20080312173155.703966894@de.ibm.com>
	 <20080312173218.186436562@de.ibm.com>
	 <1205344286.9828.91.camel@nimitz.home.sr71.net>
	 <1205363937.5237.60.camel@localhost.localdomain>
	 <20080312164303.cac9cab5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 18:49:45 +0100
Message-Id: <1205430585.5013.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 16:43 -0700, Andrew Morton wrote:
> Yes, but that's fugly and it would be better to put in place the
> infrastructure for cleaning it up, rather than worsening it.
> 
> So...

OK, we'll start the clean-up, thanks for the detailed suggestions.

--
Gerald Schaefer

