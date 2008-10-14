Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYJNBmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYJNBmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbYJNBlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:41:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35647
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbYJNBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:41:45 -0400
Date: Mon, 13 Oct 2008 18:41:21 -0700 (PDT)
Message-Id: <20081013.184121.129699101.davem@davemloft.net>
To: ron.mercer@qlogic.com
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, apw@shadowen.org, scofeldm@cisco.com,
       cooldavid@cooldavid.org
Subject: Re: [PATCH] 2.6.27-git2 - fix build error at csum_ipv6_magic()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013230957.GB26780@susedev.qlogic.org>
References: <20081013121441.GB14372@linux.vnet.ibm.com>
	<20081013230957.GB26780@susedev.qlogic.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ron Mercer <ron.mercer@qlogic.com>
Date: Mon, 13 Oct 2008 16:09:57 -0700

> Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>

I've applied Kamalesh's patch, thanks everyone.
