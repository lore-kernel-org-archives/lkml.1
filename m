Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZA0GWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZA0GWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZA0GWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:22:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53587
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbZA0GWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:22:34 -0500
Date: Mon, 26 Jan 2009 22:22:32 -0800 (PST)
Message-Id: <20090126.222232.232005024.davem@davemloft.net>
To: divy@chelsio.com
Cc: rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 2.6.30 1/2] cxgb3 - Notify fatal errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090126174605.29703.40342.stgit@speedy5>
References: <20090126174605.29703.40342.stgit@speedy5>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 26 Jan 2009 09:46:05 -0800

> Set up a notification mechanism to inform upper layer modules
> (iWARP, iSCSI) of a chip reset due to an EEH event or a fatal error.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
