Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZIUPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZIUPXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZIUPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:23:16 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47474 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554AbZIUPXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:23:15 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: Daniel Walker <dwalker@fifo99.com>
CC: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Sep 2009 09:22:44 -0600
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Thread-Topic: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Thread-Index: Aco6bVLHfVaqSigWRHyr4yd6+7QYowAYVYnA
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C5124EB@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <1253504435.9654.221.camel@desktop>
In-Reply-To: <1253504435.9654.221.camel@desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

Thanks for viewing the patches.  I did run the checkpatch.pl first before I submit the patches.  Is there possible you can tell me the errors in the specific patch, I need to find out if it is my e-mail setting problems or something else.

Thanks,

Bo Yang  

-----Original Message-----
From: Daniel Walker [mailto:dwalker@fifo99.com] 
Sent: Sunday, September 20, 2009 11:41 PM
To: Yang, Bo
Cc: James.Bottomley@HansenPartnership.com; James.Bottomley@suse.de; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix


Your patches all have numerous serious style problems.. There are far
too many to even give a summary here, and they are all different kinds
of problems..

You would need to fix all these issues before these patches could move
forward. Could you run scripts/checkpatch.pl on you patches and fix all
the issues that it reports?

Daniel

