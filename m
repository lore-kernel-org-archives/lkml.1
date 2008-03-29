Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYC2SYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYC2SYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYC2SY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:24:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50497 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYC2SY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:24:28 -0400
Date: Sat, 29 Mar 2008 19:24:27 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andreas Schwab <schwab@suse.de>
cc: Mikael Pettersson <mikpe@it.uu.se>,
       Jacek Luczak <difrost.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
In-Reply-To: <jezlshe6u7.fsf@sykes.suse.de>
Message-ID: <alpine.LNX.1.10.0803291923350.28605@fbirervta.pbzchgretzou.qr>
References: <47EE75A0.8070705@gmail.com> <18414.31274.514325.238985@harpo.it.uu.se> <jezlshe6u7.fsf@sykes.suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-03-29 19:13, Andreas Schwab wrote:
>> In a language with strict a comma-as-separator rule you can
>> get this benefit by placing the comma before new items rather
>> than after existing items:
>>
>> enum {	FOO
>> 	,FIE
>> 	,FUM
>> };
>>
>> but luckily C doesn't need this perversion.
>
> Only since C99 (but GNU C never needed it either).

C had this for much longer than 99. Borland Turbo C from around 1990
(which you can expect to be C89 if you have luck) also allows , at the end.
