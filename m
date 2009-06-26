Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZFZMjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZFZMjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbZFZMiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:38:52 -0400
Received: from mail.atmel.fr ([81.80.104.162]:34305 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257AbZFZMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:38:49 -0400
Message-ID: <4A44C148.5020406@atmel.com>
Date: Fri, 26 Jun 2009 14:38:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com
Subject: Re: [PATCH 1/3 v3] at91/USB: Add USB gadget driver selection for
 at91sam9g45 series
References: <200906190045.16496.david-b@pacbell.net> <1245776317-7134-1-git-send-email-nicolas.ferre@atmel.com> <200906252222.05258.david-b@pacbell.net>
In-Reply-To: <200906252222.05258.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell :
> On Tuesday 23 June 2009, Nicolas Ferre wrote:
>> Add gadget USB drivers for at91sam9g45 series. Those SOC include
>> high speed USB interfaces.
>> The gadget driver is the already available atmel_usba_udc.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> SAM9G45 patches aren't in mainine yet, right?  So I
> assume these can wait (maybe until 2.6.32-early).

You are right. I submit 9g45 patches to Russell patch tracking system today.

My intention is to be able to sort dependencies in linux-next tree soon.

Best regards,
-- 
Nicolas Ferre

