Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbYJJQbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbYJJQbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760473AbYJJQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:31:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54714
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759869AbYJJQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:31:09 -0400
Date: Fri, 10 Oct 2008 09:30:45 -0700 (PDT)
Message-Id: <20081010.093045.245353603.davem@davemloft.net>
To: tobias.brunner@strongswan.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc9] af_key: fix SADB_X_SPDDELETE response
From: David Miller <davem@davemloft.net>
In-Reply-To: <48EF1108.5030008@strongswan.org>
References: <48EDF4AD.50907@strongswan.org>
	<20081009.144409.170605081.davem@davemloft.net>
	<48EF1108.5030008@strongswan.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Brunner <tobias.brunner@strongswan.org>
Date: Fri, 10 Oct 2008 10:23:36 +0200

> David Miller wrote:
> > This patch does not apply cleanly to net-next-2.6, a lot has
> > changed in this area over the past several weeks.
> > Please respin this so that I can add it, thanks.
> 
> Please find the patch for net-next-2.6 below.

Please resubmit:

1) At least CC:'d to the correct mailing list, netdev@vger.kernel.org

   This is important so that the patch gets tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

2) With full commit log message and signoffs presented again.

Thanks.
