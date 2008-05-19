Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbYESVNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbYESVNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYESVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:13:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbYESVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:13:27 -0400
Date: Mon, 19 May 2008 14:13:22 -0700 (PDT)
Message-Id: <20080519.141322.31749517.davem@davemloft.net>
To: rpjday@crashcourse.ca
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Move <linux/in6.h> from header-y to unifdef-y.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805171700210.27482@localhost.localdomain>
References: <alpine.LFD.1.10.0805171700210.27482@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Date: Sat, 17 May 2008 17:02:28 -0400 (EDT)

> 
> Given that <linux/in6.h> contains a __KERNEL__ test, it should be
> unifdef-ed.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Applied, thanks Robert.
