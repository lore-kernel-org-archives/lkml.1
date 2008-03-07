Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbYCGTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbYCGTMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbYCGTMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:12:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757288AbYCGTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:12:33 -0500
Date: Fri, 07 Mar 2008 11:12:33 -0800 (PST)
Message-Id: <20080307.111233.14345956.davem@davemloft.net>
To: kamalesh@linux.vnet.ibm.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, apw@shadowen.org
Subject: Re: [BUILD_FAILURE] linux-next: Tree for March 6 build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <47D0F269.8080900@linux.vnet.ibm.com>
References: <47CFF332.4040807@linux.vnet.ibm.com>
	<20080306.111239.85901884.davem@davemloft.net>
	<47D0F269.8080900@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2008 13:14:41 +0530

> Please find the .config attached and let me know if any other
> information is needed.

While waiting for your .config I reverted the change which
caused the build failure.
