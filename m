Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbZCMUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbZCMUvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZCMUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:51:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753451AbZCMUvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:51:02 -0400
Date: Fri, 13 Mar 2009 13:50:48 -0700 (PDT)
Message-Id: <20090313.135048.202553524.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, raisch@de.ibm.com,
       tklein@de.ibm.com, themann@de.ibm.com, hering2@de.ibm.com,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH net-next-2.6] ehea: fix circular locking problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903121620.19075.ossthema@de.ibm.com>
References: <200903121620.19075.ossthema@de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan-Bernd Themann" <ossthema@de.ibm.com>
Date: Thu, 12 Mar 2009 16:20:18 +0100

> This patch fixes the circular locking problem by changing the locking strategy
> concerning the logging of firmware handles.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

Applied, thanks.
