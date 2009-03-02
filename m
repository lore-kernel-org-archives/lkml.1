Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZCBOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZCBOk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZCBOkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:40:17 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:23591 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZCBOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:40:16 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49ABEFCB.5060804@tremplin-utc.net>
Date: Mon, 02 Mar 2009 15:40:11 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lis3's ACPI dependency
References: <20090301132953.GF20813@buzzloop.caiaq.de> <49AAD3B1.4050501@tremplin-utc.net> <20090302005554.GB3223@buzzloop.caiaq.de> <49ABB22F.7040508@tremplin-utc.net> <20090302143649.GA11072@buzzloop.caiaq.de>
In-Reply-To: <20090302143649.GA11072@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> Hi Eric,
> 
> On Mon, Mar 02, 2009 at 11:17:19AM +0100, Éric Piel wrote:
>>> Ok, I'll start and seperate things then but will need you help with
>>> testing as I don't have the hardware the driver was written for
>>> originally. I do have, in turn, a custom board with this chip connected
>>> via SPI.
>> Very good.
> 
> Ok, just send a series of 5 patches. For some reason, git send-email ate
> up the subject lines of the first two, sorry for that.
> 
> All together they do what I want - I can use the device now on my PXA
> board. There might be some more updates I'll come up with later. For
> now, I'd like to make sure I didn't break anything for HP laptops :)
Will try to find some time tonight or tomorrow to test them.
At first sight they look good :-)

Eric
