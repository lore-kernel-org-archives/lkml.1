Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYLSAqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYLSAqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYLSAqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:46:35 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2582 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYLSAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:46:34 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: RE: [PATCH] Stop scaring users with "treason uncloaked!"
Date: Thu, 18 Dec 2008 16:45:32 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEJJBPAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <1229641573.3726.563.camel@calx>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 18 Dec 2008 16:47:50 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 18 Dec 2008 16:47:50 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Most people won't actually think their printer is on fire. But most
> people WILL think there is serious cause for concern when they see this
> for the first time in dmesg. Many will search the net for explanations
> and come away confused and not entirely reassured. And at least one
> clueless guy will call the police because he still thinks he's under
> attack.

Messages about something or other being "illegal" occur about 345 times in
the Linux kernel source code. Are we going to start patching those too?

We have "illegal norm", "illegal input", "illegal call", "illegal type",
"illegal bits", "illegal root port number", "illegal host number", "illegal
DMA data", "illegal dimensions" (who do you call about that one?), "illegal
phase", "illegal page number", "illegal seek", and on, and on, and on.

I suspect that if I submitted a patch to change all of those to "invalid",
I'd be considered a kook. (Well, more of a kook, anyway.)

DS


