Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZJWOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZJWOTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZJWOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:19:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbZJWOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:19:23 -0400
Date: Fri, 23 Oct 2009 07:19:46 -0700 (PDT)
Message-Id: <20091023.071946.127289624.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: sparc64 cmpxchg is not a full memory barrier anymore ?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091023123327.GA14058@Krystal>
References: <20091022183242.GA19307@Krystal>
	<20091022.145645.249762938.davem@davemloft.net>
	<20091023123327.GA14058@Krystal>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Fri, 23 Oct 2009 08:33:27 -0400

> OK. Perhaps adding a comment to that effect near sparc mb()
> implementation would be appropriate ?

Sure, I'll take care of that when I get back from Japan.
