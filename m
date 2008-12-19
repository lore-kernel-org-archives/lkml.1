Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYLSA4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYLSA4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYLSAzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:55:54 -0500
Received: from khc.piap.pl ([195.187.100.11]:47999 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYLSAzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:55:53 -0500
To: davids@webmaster.com
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
References: <MDEHLPKNGKAHNMBLJOLKKEJJBPAD.davids@webmaster.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 19 Dec 2008 01:55:51 +0100
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEJJBPAD.davids@webmaster.com> (David Schwartz's message of "Thu\, 18 Dec 2008 16\:45\:32 -0800")
Message-ID: <m3r645nfu0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Schwartz" <davids@webmaster.com> writes:

> Messages about something or other being "illegal" occur about 345 times in
> the Linux kernel source code. Are we going to start patching those too?

I think we should.
Except for those which are part of some reasonable userspace interface.
-- 
Krzysztof Halasa
