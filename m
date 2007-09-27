Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXI0IkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXI0IkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXI0Ij6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:39:58 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:2681 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbXI0Ij5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:39:57 -0400
X-IronPort-AV: E=Sophos;i="4.21,202,1188770400"; 
   d="scan'208";a="3316572"
Date: Thu, 27 Sep 2007 10:39:55 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, balbir@in.ibm.com, jlan@engr.sgi.com,
       jlim@sgi.com, oleg@tv-sign.ru
Subject: Re: [PATCH 1/8] taskstats: fix indentation of long argument lists
Message-ID: <20070927103955.66ed4755@cheypa.inria.fr>
In-Reply-To: <20070926130144.78ab9491.akpm@linux-foundation.org>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
	<20070926130144.78ab9491.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.1cvs20 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 26 Sep 2007 13:01:44 -0700,
Andrew Morton <akpm@linux-foundation.org> a écrit :

> Also, I don't think we're seeing enough review and test from people on
> these patch series - I don't have time to do it all.  (Well, apparently I
> do, but I don't think it's a good situation).

I don't object to your decision, but I think it's a bit unfair to
Balbir and Oleg "sharp eye" Nesterov.

Going to hammer 2.6.23-rc8-mm1 ;-)

-- 
Guillaume
