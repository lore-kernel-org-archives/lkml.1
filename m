Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZJQAxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZJQAxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZJQAxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:53:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53017
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbZJQAxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:53:51 -0400
Date: Fri, 16 Oct 2009 17:54:13 -0700 (PDT)
Message-Id: <20091016.175413.236830274.davem@davemloft.net>
To: bhavesh@vmware.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, pv-drivers@vmware.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [Pv-drivers] [PATCH -next] vmxnet3: use dev_dbg, fix build for
 CONFIG_BLOCK=n
From: David Miller <davem@davemloft.net>
In-Reply-To: <8B1F619C9F5F454E81D90D3C161698D7017DD56435@EXCH-MBX-3.vmware.com>
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au>
	<4AD7A24F.6000900@oracle.com>
	<8B1F619C9F5F454E81D90D3C161698D7017DD56435@EXCH-MBX-3.vmware.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bhavesh Davda <bhavesh@vmware.com>
Date: Thu, 15 Oct 2009 15:35:02 -0700

> Who ever compiles with CONFIG_BLOCK=n? Just kidding...

Who ever uses block layer debugging facilities in a networking
driver?

> Thanks again for making this change! Ship it!
> 
> Signed-off-by: Bhavesh Davda <bhavesh@vmware.com>

Applied, thanks everyone.
