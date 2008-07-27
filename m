Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYG0Ivc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYG0Ivc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 04:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYG0IvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 04:51:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:51789 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYG0IvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 04:51:24 -0400
Subject: Re: [PATCH 0/5] powerpc tracehook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: roland@redhat.com, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080727.005518.08712012.davem@davemloft.net>
References: <20080727064859.69692154280@magilla.localdomain>
	 <1217145165.11188.132.camel@pasglop>
	 <20080727.005518.08712012.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 18:51:01 +1000
Message-Id: <1217148661.11188.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Thanks for this. I haven't followed the story of tracehook so far, are
> > those patches dependent on something else or it's all already upstream
> > and do you think that's still 2.6.27 material ?
> 
> The infrastructure is in Linus's tree.

Thanks David. I'll review these on monday and if Paul has no objection,
I suppose we can still merge them.

Cheers,
Ben.


