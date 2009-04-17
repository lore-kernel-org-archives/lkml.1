Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZDQAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZDQAsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbZDQAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:44:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40565
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760914AbZDQAoP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:44:15 -0400
Date: Thu, 16 Apr 2009 17:44:06 -0700 (PDT)
Message-Id: <20090416.174406.120779583.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       fragabr@gmail.com, herbert@gondor.apana.org.au
Subject: Re: [Bug #13097] Kernel will freeze network after using a tun/tap
 device
From: David Miller <davem@davemloft.net>
In-Reply-To: <nY3-4PrO6XH.A.E-.fw85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<nY3-4PrO6XH.A.E-.fw85JB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 16 Apr 2009 23:45:02 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13097
> Subject		: Kernel will freeze network after using a tun/tap device
> Submitter	: Dâniel Fraga <fragabr@gmail.com>
> Date		: 2009-04-15 22:19 (2 days old)

Herbert what's the state of this?  Is this fixed already as of what I
pushed earlier today to Linus, or are the two patches you are working
on cure this?

Thanks.
