Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYDBQj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYDBQj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbYDBQjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:39:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50169 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYDBQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:39:20 -0400
Message-ID: <47F3C469.1020803@oracle.com>
Date: Wed, 02 Apr 2008 12:37:45 -0500
From: Richard Frank <richard.frank@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Scott Weitzenkamp (sweitzen)" <sweitzen@cisco.com>
CC: "Roland Dreier (rdreier)" <rdreier@cisco.com>, rds-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what'sin
 infiniband.git)
References: <adave31bayd.fsf@cisco.com>	<1207120932.4593.47.camel@localhost.localdomain>	<aday77w2s5z.fsf@cisco.com><47F3BE33.4000204@oracle.com> <adalk3w2pxz.fsf@cisco.com> <47F3C137.3070209@oracle.com> <A15335FBE9BD2449AF2C9EF3D1EB8EA3055471E8@xmb-sjc-216.amer.cisco.com>
In-Reply-To: <A15335FBE9BD2449AF2C9EF3D1EB8EA3055471E8@xmb-sjc-216.amer.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe there is a patch for NetPerf which supports RDS - although it 
may need to be updated - and submitted.

The only prior discussion I can think of - was whether or not NetPerf 
exercises RDS as Oracle would.

I'm not proposing that we should enhance NetPerf to do that (but that's 
OK with me).

We created a tool rds-stress which does that.

Scott Weitzenkamp (sweitzen) wrote:
>> WRT to merging RDS into the kernel - our current plans are to wait to 
>> see RDS adopted by more than Oracle - before approaching the kernel 
>> community about inclusion of RDS.
>>     
>
> I've seen statements before from someone from Oracle that RDS was only
> for Oracle's use, for example, that person did not want netperf changed
> to support RDS.
>
> Scott Weitzenkamp
> SQA and Release Manager
> Data Center Access Engineering
> Cisco Systems
>   
