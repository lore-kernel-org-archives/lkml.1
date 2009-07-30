Return-Path: <linux-kernel-owner+w=401wt.eu-S1751140AbZG3EmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbZG3EmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 00:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZG3EmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 00:42:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46578
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbZG3EmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 00:42:00 -0400
Date: Wed, 29 Jul 2009 21:42:07 -0700 (PDT)
Message-Id: <20090729.214207.193697413.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: dhananjay@netxen.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH NEXT] netxen: fix CONFIG_INET=n build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090728122352.6d4a2b05.randy.dunlap@oracle.com>
References: <1248808203-9578-1-git-send-email-dhananjay@netxen.com>
	<20090728122352.6d4a2b05.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 28 Jul 2009 12:23:52 -0700

> On Tue, 28 Jul 2009 12:10:03 -0700 Dhananjay Phadke wrote:
> 
>> Wrap dest IP hashing code with #ifdef CONFIG_INET,
>> this feature makes no sense without INET, but other
>> driver can still work.
>> 
>> Signed-off-by: Dhananjay Phadke <dhananjay@netxen.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks.
