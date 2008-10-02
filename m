Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYJBBw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYJBBw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYJBBwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:52:47 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:21883 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJBBwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:52:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
Date: Thu, 2 Oct 2008 09:52:43 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB807DC7F62@exchtp03.taipei.via.com.tw>
In-Reply-To: <48E4272A.1090105@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
Thread-Index: AckkMIP9Cjfy5NPfT0666uHv/uTijQAAJg+g
From: <JosephChan@via.com.tw>
To: <tj@kernel.org>, <akpm@linux-foundation.org>
Cc: <scottpitcher@netspace.net.au>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 02 Oct 2008 01:52:44.0665 (UTC) FILETIME=[901DF690:01C92431]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun.

Sorry, I'm not familiar with git. 
Would you please send me a link to download? 

In addition, I'm on vacation between 10/3 ~ 10/12.
I will test it after I'm back.

BRs,
Joseph Chan 

-----Original Message-----
From: Tejun Heo [mailto:tj@kernel.org] 
Sent: Thursday, October 02, 2008 9:43 AM
To: Andrew Morton
Cc: Scott Pitcher; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Joseph Chan
Subject: Re: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem

Tejun Heo wrote:
> Hello,
> 
> Can you please test the attached patch?  It's on top of the upstream 
> branch of Jeff's libata-dev tree.
> 
>   http://www.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>   git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> If you're unfamiliar with git, just lemme know.  I'll send you a patch 
> against 2.6.27-rc8.

And I of course forgot to actually attach the patch.

--
tejun
