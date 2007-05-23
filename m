Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXEWU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXEWU0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXEWU0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:26:22 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:61038 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757447AbXEWU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:26:21 -0400
Message-ID: <4654A3C8.9010908@ru.mvista.com>
Date: Thu, 24 May 2007 00:27:52 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.21.1: ide-pci is not finding ide controller.
References: <20070523201118.GZ5921@austin.ibm.com> <20070523212425.68897280@the-village.bc.nu>
In-Reply-To: <20070523212425.68897280@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

>>I've got a rather old x86 box that I'm booting 2.6.21.1 on;
>>this kernel is not finding an ide controller on it. 

> HPT366 fixes were posted here earlier. It doesn't in fact have reliable
> enable bits.

   HPT36x either didn't have them yet or they were located in different place. 
Who knows -- I've never seen the specs...

MBR, Sergei
