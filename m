Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZLBDuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZLBDuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZLBDuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:50:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:42670 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZLBDuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:50:15 -0500
Date: Wed, 2 Dec 2009 14:49:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Michal Schmidt <mschmidt@redhat.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       jkj@kapsi.fi, linux-kernel@vger.kernel.org, dhowells@redhat.com,
       serue@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] bsdacct: fix uid/gid misreporting (#14676)
In-Reply-To: <20091201184957.27a2aaab@leela>
Message-ID: <alpine.LRH.2.00.0912021447360.31002@tundra.namei.org>
References: <20091130224032.GA5598@x200.malnet.ru> <20091201184957.27a2aaab@leela>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Michal Schmidt wrote:

> Ah, indeed. The original commit went into 2.6.31-stable so this one
> should too.
> 
> Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
> 

This should probably go to Linus' tree in akpm's next batch.


-- 
James Morris
<jmorris@namei.org>
