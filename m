Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZBKXBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZBKXBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZBKXBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:01:02 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbZBKXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:01:00 -0500
Date: Wed, 11 Feb 2009 15:00:53 -0800 (PST)
Message-Id: <20090211.150053.02539000.davem@davemloft.net>
To: swise@opengridcomputing.com
Cc: rdreier@cisco.com, general@lists.openfabrics.org, randy.dunlap@oracle.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.30] RDMA/cxgb3: remove modulo math from
 build_rdma_recv().
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090211222915.19520.22647.stgit@dell3.ogc.int>
References: <20090211222915.19520.22647.stgit@dell3.ogc.int>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>
Date: Wed, 11 Feb 2009 16:29:15 -0600

> From: Steve Wise <swise@opengridcomputing.com>
> 
> - remove modulo usage
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>

Acked-by: David S. Miller <davem@davemloft.net>
