Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZFSXDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZFSXDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZFSXDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:03:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42042
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbZFSXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:03:00 -0400
Date: Fri, 19 Jun 2009 16:03:04 -0700 (PDT)
Message-Id: <20090619.160304.43776849.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: rientjes@google.com, eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1ljnoyn0e.fsf@fess.ebiederm.org>
References: <alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
	<20090618.123708.78849607.davem@davemloft.net>
	<m1ljnoyn0e.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 19 Jun 2009 13:41:37 -0700

> But Mr. Reintjes if you really want the traces I can set up 
> an script to email them to you every time it happens.  Say about
> 1 a minute from my paltry little farm of machines.

Same here :-)
