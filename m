Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZFBFmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZFBFmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbZFBFl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:41:58 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:3504 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758095AbZFBFl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:41:58 -0400
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT7199741099349.TMP
Subject: Re: [Fwd: Re: [PATCH]:RESEND : Return proper error value on
	failure of dentry_open]
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Eric Paris <eparis@redhat.com>,
       Kylene J Hall <kylene@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Reiner Sailer <sailer@watson.ibm.com>, serue@linux.vnet.ibm.com,
       safford@watson.ibm.com
In-Reply-To: <OF4496A6A3.97A7AC73-ON852575C8.004E887B-852575C8.0051176D@us.ibm.com>
References: <1243849610.2234.3.camel@system> <4A23A690.6070504@gmail.com>
	 <4A23A72E.3020506@gmail.com>
	 <OF4496A6A3.97A7AC73-ON852575C8.004E887B-852575C8.0051176D@us.ibm.com>
Content-Type: text/plain
Organization: CMS
Date: Tue, 02 Jun 2009 11:14:20 +0530
Message-Id: <1243921460.2170.15.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,
	Thanks for replying.
> > [But the fix in -next still misses 'return 0' -> 'return rc' which I
> > though you had tried to change.]
> 
> At this point, we're just collecting measurements, not appraising 
> them. The return code will be the result of appraise_measurement(). 
> For now, the dentry_open shouldn't fail, but if it does, we probably
> should audit it.
> 
Can you please change that comment.
Thanks & Regards
vibi sreenivasan
> Mimi Zohar
> 
> 


