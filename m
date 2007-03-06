Return-Path: <linux-kernel-owner+w=401wt.eu-S965842AbXCFLI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842AbXCFLI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965844AbXCFLI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:08:26 -0500
Received: from mail10.tpgi.com.au ([203.12.160.147]:34814 "EHLO
	mail10.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965842AbXCFLIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:08:25 -0500
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 06:08:24 EST
X-TPG-Antivirus: Passed
Subject: Re: [ckrm-tech] [PATCH 3/3][RFC] Containers: Pagecache controller
	reclaim
From: Shane <ibm-main@tpg.com.au>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       xemul@sw.ru, menage@google.com, devel@openvz.org, clameter@sgi.com
In-Reply-To: <20070305145311.247699000@linux.vnet.ibm.com>>
References: <20070305145237.003560000@linux.vnet.ibm.com> >
	  <20070305145311.247699000@linux.vnet.ibm.com>>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 20:50:11 +1000
Message-Id: <1173178212.4998.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone else have trouble fitting this patch ???.
I see a later version today, but not markedly different from this
mornings (Aus time). Initially I thought I had the first version, prior
to Balbir's RSS controller V2 re-write, but apparently not.
Kernel 2.6.20.1

Had to toss it away so I could do some base line testing - I'll redo the
build and see where the mis-matches are.

Shane ...

