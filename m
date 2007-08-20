Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXHTAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXHTAkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXHTAkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:40:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44243
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXHTAkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:40:18 -0400
Date: Sun, 19 Aug 2007 17:40:17 -0700 (PDT)
Message-Id: <20070819.174017.77241227.davem@davemloft.net>
To: felix@chelsio.com
Cc: sean.hefty@intel.com, netdev@vger.kernel.org, rdreier@cisco.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
 PS_TCPportsfrom the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E20BC@maui.asicdesigners.com>
References: <8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com>
	<20070819.160428.76330262.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E20BC@maui.asicdesigners.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felix Marti" <felix@chelsio.com>
Date: Sun, 19 Aug 2007 17:32:39 -0700

[ Why do you put that "[Felix Marti]" everywhere you say something?
  It's annoying and superfluous. The quoting done by your mail client
  makes clear who is saying what. ]

> Hmmm, interesting... I guess it is impossible to even have
> a discussion on the subject.

Nice try, Herbert Xu gave a great explanation.
