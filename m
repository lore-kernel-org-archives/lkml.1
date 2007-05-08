Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbXEHILF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbXEHILF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934497AbXEHILB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:11:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934405AbXEHILA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:11:00 -0400
Subject: Re: [PATCH] DLM: fix a couple of races
From: Steven Whitehouse <swhiteho@redhat.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: linux-kernel@vger.kernel.org, teigland@redhat.com,
       linux-cluster@redhat.com, joel.becker@oracle.com
In-Reply-To: <1178611258.7476.5.camel@quoit>
References: <Pine.LNX.4.64.0705042119510.16239@cselinux1.cse.iitk.ac.in>
	 <1178611258.7476.5.camel@quoit>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 08 May 2007 09:10:19 +0100
Message-Id: <1178611819.7476.7.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2007-05-08 at 09:00 +0100, Steven Whitehouse wrote:
> Hi,
> 
> Added to the GFS2 -nmw git tree, thanks. Please remember to add a
> Signed-off-by line for future patches - I've added it for you this time,
> 
> Steve.
> 
Sorry - I just spotted that you did add a signed-off-by but git ate it
for some reason. I've fixed it up anyway, sorry about that,

Steve.


