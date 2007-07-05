Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbXGERVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbXGERVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbXGERV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:21:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26404 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbXGERV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:21:27 -0400
In-Reply-To: <1183655819.19473.0.camel@dyn9047017100.beaverton.ibm.com>
References: <46832499.40807@us.ibm.com> <5A6608DF-EDC3-43C1-BFB7-58ACBF94DBCB@oracle.com> <46859DE2.9040604@us.ibm.com>  <20070703222855.GA6293@mami.zabbo.net> <1183602311.29435.1.camel@dyn9047017100.beaverton.ibm.com> <3439F83E-9FBD-4743-B2A9-63009B7087FD@oracle.com> <1183655819.19473.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <6ABBC539-4EDC-494D-8399-6C75673A99AC@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] dio: remove bogus refcounting BUG_ON
Date: Thu, 5 Jul 2007 10:21:13 -0700
To: Badari Pulavarty <pbadari@us.ibm.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> What are they doing to reproduce it?  How much setup does it take?
>
> Huge OLTP run :(

Darn :(

> I will ask them to try that.

Great, thanks.

- z
