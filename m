Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbXKTXs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbXKTXs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXKTXsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:48:19 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:45512 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbXKTXsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:48:18 -0500
Message-ID: <47437241.7040303@freescale.com>
Date: Tue, 20 Nov 2007 17:48:17 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: [PATCH try2] powerpc: Add support for PORTA and PORTB odr registers
References: <474316A4.4010807@scram.de>
In-Reply-To: <474316A4.4010807@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> PORTA and PORTB have odr registers, as well. However, the PORTB odr
> register is only 16bit.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>

Acked-by: Scott Wood <scottwood@freescale.com>

BTW, you may want to send the patches to linuxppc-dev rather than 
linuxppc-embedded...  Despite what MAINTAINERS says, the former is where 
most patches get posted.

-Scott
