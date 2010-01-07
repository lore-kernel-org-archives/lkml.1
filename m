Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367Ab0AGWLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0AGWLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258Ab0AGWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:11:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42322
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190Ab0AGWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:11:14 -0500
Date: Thu, 07 Jan 2010 14:11:23 -0800 (PST)
Message-Id: <20100107.141123.93463437.davem@davemloft.net>
To: joe@perches.com
Cc: mirqus@gmail.com, hartleys@visionengravers.com, macro@linux-mips.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2] lib/vsprintf.c: Add %pMF to format FDDI bit
 reversed MAC addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1262900238.10429.78.camel@Joe-Laptop.home>
References: <1262888625.10429.23.camel@Joe-Laptop.home>
	<e2d7436a1001071318l75750b29uece2a61884538d5b@mail.gmail.com>
	<1262900238.10429.78.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 07 Jan 2010 13:37:18 -0800

> Adds 6 bytes to object size for x86

Sweet!
