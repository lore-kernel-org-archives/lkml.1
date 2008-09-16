Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYIPBgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYIPBgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 21:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYIPBgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 21:36:09 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:19761 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYIPBgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 21:36:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=G13gxcjPzH962DTETqgA:9 a=fuQzuXiHpdvIcCRabfoA:7 a=AJl8zeG90Mw45emWW_gr1S7vPZcA:4 a=pW7vqf3uvfcA:10 a=bCndXJ7GUCUA:10
Message-ID: <48CF0D84.7060804@shaw.ca>
Date: Mon, 15 Sep 2008 19:36:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Buffer I/O error on device sr0, logical block 793066
References: <fa.RthRteIKyDr2XSXrOGnYRXbkLXg@ifi.uio.no>
In-Reply-To: <fa.RthRteIKyDr2XSXrOGnYRXbkLXg@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> I guess russell crow doesnt have a problem with me(Gladiator), but
> as soon as jodie foster is the main character(Panic Room);
>  I receieve this:
> 
> 
> [14417.951134] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> [14417.951150] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
> [14417.951160] Info fld=0xc1a00
> [14417.951163] sr 0:0:0:0: [sr0] Add. Sense: Track following error
> [14417.951172] end_request: I/O error, dev sr0, sector 3172264

"Track following error" comes right from the drive, it can't read the 
disc properly. Scratched perhaps?
