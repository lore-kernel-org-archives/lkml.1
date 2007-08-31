Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbXHaUUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbXHaUUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXHaUUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:20:04 -0400
Received: from h155.mvista.com ([63.81.120.155]:44980 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755005AbXHaUUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:20:02 -0400
Message-ID: <46D87899.30006@ru.mvista.com>
Date: Sat, 01 Sep 2007 00:22:49 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: John Sigler <linux.kernel@free.fr>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete
 Error }
References: <46D59ED2.4000900@free.fr> <20070829174657.09c7de3c@the-village.bc.nu>
In-Reply-To: <20070829174657.09c7de3c@the-village.bc.nu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>Standards:
>>         Likely used: 1

> Prehistory

>>         LBA, IORDY not likely

> No DMA, nothing above PIO2

    Cool! :-)

>>         Buffer type: 0002: dual port, multi-sector
>>         Buffer size: 1.0kB      bytes avail on r/w long: 4
>>         Cannot perform double-word IO

> Can't even do double word I/O

    I have alwayas wondered what the drive's part in 32-bit I/O... this seems 
to be controller's problem exclusively. B-)

WBR, Sergei
