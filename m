Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXCEP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXCEP7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbXCEP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:59:39 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:15903 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575AbXCEP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:59:37 -0500
Reply-To: <vyekkirala@trustedcs.com>
From: "Venkat Yekkirala" <vyekkirala@trustedcs.com>
To: "'Eric Paris'" <eparis@parisplace.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <jmorris@namei.org>,
       "Venkat Yekkirala" <vyekkirala@tcsfw4.tcs-sec.com>,
       <cxzhang@watson.ibm.com>, <sds@tycho.nsa.gov>
Subject: RE: [PATCH] Add xfrm policy change auditing to pfkey_spdget
Date: Mon, 5 Mar 2007 09:59:14 -0600
Message-ID: <001601c75f3f$394d8af0$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: <1172861484.31047.26.camel@localhost.localdomain>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> pfkey_spdget neither had an LSM security hook nor auditing for the
> removal of xfrm_policy structs.  The security hook was added 
> when it was
> moved into xfrm_policy_byid instead of the callers to that function by
> my earlier patch and this patch adds the auditing hooks as well.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Venkat Yekkirala <vyekkirala@trustedcs.com>  
