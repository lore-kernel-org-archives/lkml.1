Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbXCEQA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbXCEQA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXCEQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:00:31 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:1164 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580AbXCEQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:00:21 -0500
Reply-To: <vyekkirala@TrustedCS.com>
From: "Venkat Yekkirala" <vyekkirala@TrustedCS.com>
To: "Venkat Yekkirala" <vyekkirala@tcsfw4.tcs-sec.com>,
       "'Eric Paris'" <eparis@parisplace.org>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <jamesm@namei.org>, <cxzhang@watson.ibm.com>,
       <sds@tycho.nsa.gov>, <latten@austin.ibm.com>
Subject: RE: [PATCH] xfrm_policy delete security check misplaced
Date: Mon, 5 Mar 2007 09:36:01 -0600
Message-ID: <001401c75f3b$fb9da3f0$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: 
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Also, [Joy cc'd] deletions here needn't be audited?

OK, I see the next patch addressed this :)
