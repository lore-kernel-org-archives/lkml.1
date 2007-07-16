Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbXGPQsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbXGPQsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbXGPQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:48:00 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:8158 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120AbXGPQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:47:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAOI9m0arR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="8732464:sNHT1859953578"
To: Shirley Ma <xma@us.ibm.com>
Cc: general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <OF419657E7.3098466C-ON87257317.0067BBE6-88257317.0067EA65@us.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 09:47:52 -0700
Message-ID: <ada644kxpl3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 16:47:53.0080 (UTC) FILETIME=[0D6AB780:01C7C7C9]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >         FYI, we are working on several IPoIB performance improvement 
 > patches which are not on the list. Some of the patches are under test, 
 > some of the patches are going to be submitted soon. They are:

There is less than a week left in the merge window, and none of these
changes has been reviewed yet.  So being realistic, I don't think we
can expect to get any of this into 2.6.23.

 - R.
