Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYDBQ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYDBQ35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYDBQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:29:49 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:4077 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbYDBQ3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:29:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what'sin infiniband.git)
Date: Wed, 2 Apr 2008 09:29:43 -0700
Message-ID: <A15335FBE9BD2449AF2C9EF3D1EB8EA3055471E8@xmb-sjc-216.amer.cisco.com>
In-Reply-To: <47F3C137.3070209@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what'sin infiniband.git)
Thread-Index: AciU3h41TD9q8gaoSGSBiTmYR5cyXQAAHIjg
References: <adave31bayd.fsf@cisco.com>	<1207120932.4593.47.camel@localhost.localdomain>	<aday77w2s5z.fsf@cisco.com><47F3BE33.4000204@oracle.com> <adalk3w2pxz.fsf@cisco.com> <47F3C137.3070209@oracle.com>
From: "Scott Weitzenkamp (sweitzen)" <sweitzen@cisco.com>
To: "Richard Frank" <richard.frank@oracle.com>,
       "Roland Dreier (rdreier)" <rdreier@cisco.com>
Cc: <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
       <general@lists.openfabrics.org>
X-OriginalArrivalTime: 02 Apr 2008 16:29:47.0573 (UTC) FILETIME=[C4383E50:01C894DE]
Authentication-Results: sj-dkim-3; header.From=sweitzen@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> WRT to merging RDS into the kernel - our current plans are to wait to 
> see RDS adopted by more than Oracle - before approaching the kernel 
> community about inclusion of RDS.

I've seen statements before from someone from Oracle that RDS was only
for Oracle's use, for example, that person did not want netperf changed
to support RDS.

Scott Weitzenkamp
SQA and Release Manager
Data Center Access Engineering
Cisco Systems
