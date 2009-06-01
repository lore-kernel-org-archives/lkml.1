Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZFAKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZFAKfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZFAKfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:35:36 -0400
Received: from mailgw3.cms.com ([202.75.200.223]:53025 "EHLO cms.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755075AbZFAKfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:35:36 -0400
X-Originating-IP: 172.19.23.105
X-Auth-User: vibi_sreenivasan@cms.com
X-Filename: C:\PROGRA~1\MailScan\in\SMT1011460117964.TMP
Subject: Re: [Fwd: Re: [PATCH]:RESEND : Return proper error value on
	failure of dentry_open]
From: vibi sreenivasan <vibi_sreenivasan@cms.com>
Reply-To: vibi_sreenivasan@cms.com
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A23A72E.3020506@gmail.com>
References: <1243849610.2234.3.camel@system> <4A23A690.6070504@gmail.com>
	 <4A23A72E.3020506@gmail.com>
Content-Type: text/plain
Organization: CMS
Date: Mon, 01 Jun 2009 16:07:43 +0530
Message-Id: <1243852663.2234.11.camel@system>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8)
Content-Transfer-Encoding: 7bit
X-Trained: 2
X-MS-ContentScanSkipped: Mail Not From Internet
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> > Aha, you use linus's git. This has been fixed by
> > f06dd16a03f6f7f72fab4db03be36e28c28c6fd6
> > (IMA: Handle dentry_open failures)
> > in -next.
 Thanks alot .i was not much aware of linux-next usage.
 I will checkout that.
> 
> [But the fix in -next still misses 'return 0' -> 'return rc' which I
> though you had tried to change.]
 I will checkout as you said & try to put 'return rc' in place.

Thanks & regards
vibi sreenivasan
> 
> 


