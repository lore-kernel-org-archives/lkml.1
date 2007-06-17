Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbXFQR4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbXFQR4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbXFQR4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:56:32 -0400
Received: from ms.trustica.cz ([82.208.32.68]:37118 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbXFQR4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:56:31 -0400
Message-ID: <467575BF.1090207@assembler.cz>
Date: Sun, 17 Jun 2007 19:56:15 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path
References: <1182026585.4230.8.camel@localhost>	 <20070616231745.1b0f7bd9@hyperion.delvare> <1182071803.4815.5.camel@localhost>
In-Reply-To: <1182071803.4815.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Sorry for the delay, I was hiking in the mountains.

> this patch indeed fixes the problem. Thanks!

Jean, thanks for the quick fix! Well obviously my fault :/ Sorry.

> Unfortunately the coretemp sensors are simply never there when that
> patch is applied... which I guess was the intention ... As apple
> probably won't update the bios does anyone know how to get a newer
> microcode for a core duo cpu  (not core 2 duo!) ?

Well it seems that it is not included in http://www.urbanmyth.org/microcode/
So I would recommend getting it from some BIOS from other vendor. You will need 
to decompress the BIOS and get the microcode from there. If you will find some 
BIOS for Core duo ntbk I might help with that. Just send me a URL for download 
and I will try to dig it out (with some luck there will be some update ;)

Rudolf
