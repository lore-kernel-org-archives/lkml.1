Return-Path: <linux-kernel-owner+w=401wt.eu-S1762526AbXGJTyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526AbXGJTyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbXGJTy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:54:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:16340 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755670AbXGJTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:54:25 -0400
Message-ID: <4693E46A.4020900@ru.mvista.com>
Date: Tue, 10 Jul 2007 23:56:26 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: ata and netdev (was Re: -mm merge plans for 2.6.23)
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <4693C4F8.40903@garzik.org>
In-Reply-To: <4693C4F8.40903@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>> 3x59x-fix-pci-resource-management.patch

    Now that the fix for CONFIG_PCI=n has been merged, what's left is to test 
this on EISA (at least Andrew wanted it :-).

>>  netdev patches which are stuck in limbo land.

> ?  I don't think I've seen these.

    You should have, I was sending it to you.

WBR, Sergei
