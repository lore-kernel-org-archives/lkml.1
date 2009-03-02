Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZCBKRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZCBKRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZCBKRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:17:24 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:6214 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZCBKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:17:23 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49ABB22F.7040508@tremplin-utc.net>
Date: Mon, 02 Mar 2009 11:17:19 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
References: <20090301132953.GF20813@buzzloop.caiaq.de> <49AAD3B1.4050501@tremplin-utc.net> <20090302005554.GB3223@buzzloop.caiaq.de>
In-Reply-To: <20090302005554.GB3223@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:

> 
> Ok, I'll start and seperate things then but will need you help with
> testing as I don't have the hardware the driver was written for
> originally. I do have, in turn, a custom board with this chip connected
> via SPI.
Very good.

> Is there any patch pending on top of Linus' current git head that I
> should base my patches on?
There are a couple of clean-up patches from Pavel hanging around in the
-mm tree. See hp_accel* in http://userweb.kernel.org/~akpm/mmotm/broken-out/

Eric
