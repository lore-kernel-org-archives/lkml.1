Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZKQSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZKQSIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZKQSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:08:41 -0500
Received: from lo.gmane.org ([80.91.229.12]:53257 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbZKQSIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:08:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
Date: Tue, 17 Nov 2009 17:37:37 +0000
Message-ID: <1k3bt6-t1b.ln1@chipmunk.wormnet.eu>
References: <faf197be196ee.196eefaf197be@huawei.com> <20091117.012248.86306050.davem@davemloft.net> <4B0278D9.6030806@gmail.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson <william.allen.simpson@gmail.com> wrote:
>
> And your trailer boilerplate badly breaks the system, because it's
> missing the SMTP email standard "--" line in front of it.
> 
*ahem* s/^--$/^-- $/ *ahem*

Two hyphens followed by a space.

Cheers

-- 
Alexander Clouter
.sigmonster says: Everything you know is wrong!

