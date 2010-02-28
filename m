Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031537Ab0B1IMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:12:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031462Ab0B1IMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:12:17 -0500
Date: Sun, 28 Feb 2010 00:12:35 -0800 (PST)
Message-Id: <20100228.001235.112611882.davem@davemloft.net>
To: andrea.gelmini@gelma.net
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       coreteam@netfilter.org
Subject: Re: [PATCH 40/66]
 include/linux/netfilter/nf_conntrack_tuple_common.h: Checkpatch cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267289508-31031-41-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	<1267289508-31031-41-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>
Date: Sat, 27 Feb 2010 17:51:21 +0100

> include/linux/netfilter/nf_conntrack_tuple_common.h:5: ERROR: open brace '{' following enum go on the same line
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Acked-by: David S. Miller <davem@davemloft.net>
