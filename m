Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbXKLTea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbXKLTea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKLTeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:34:22 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:56228 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXKLTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:34:22 -0500
Message-ID: <4738909C.6030407@freescale.com>
Date: Mon, 12 Nov 2007 11:42:52 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: Add support for PORTA sor and PORTB odr registers
References: <473736FB.7090609@scram.de>
In-Reply-To: <473736FB.7090609@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> PORTA has an so register and PORTB had an odr register, as well.
> However, the PORTB odr register is only 16bit.

Which 8xx chip has a so register on port A?  I checked the 860, 866, 
885, and 823 manuals and didn't see one.

-Scott
