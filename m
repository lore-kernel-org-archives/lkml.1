Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZCMSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZCMSsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZCMSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:48:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38880
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbZCMSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:48:40 -0400
Date: Fri, 13 Mar 2009 11:48:26 -0700 (PDT)
Message-Id: <20090313.114826.227438034.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-kernel@vger.kernel.org, ivecera@redhat.com, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] 8139too: allow to set mac address on running device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090313175834.GE3436@psychotron.englab.brq.redhat.com>
References: <20090313175834.GE3436@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Fri, 13 Mar 2009 18:58:35 +0100

> Similar patch as for 8139cp posted yesterday, so the same comment:
> 
> So far there was not a chance to set a mac address on running 8139too device.
> This is for example needed when you want to use this NIC as a bonding slave in
> bonding device in mode balance-alb. This simple patch allows it.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Also applied, thanks.
