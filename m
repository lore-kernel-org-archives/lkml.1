Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZKBRTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZKBRTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZKBRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:19:05 -0500
Received: from mail.atmel.fr ([81.80.104.162]:44443 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753832AbZKBRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:19:03 -0500
Message-ID: <4AEF1466.8090203@atmel.com>
Date: Mon, 02 Nov 2009 18:18:30 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org, haavard.skinnemoen@atmel.com,
       akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3 v2] mmc: atmel-mci: New MCI2 module support in atmel-mci
 driver
References: <20090930155557.7dae503b@hskinnemoen-d830> <af570068c8bd25f207dd3a43b8acd7cf645b21af.1256314995.git.nicolas.ferre@atmel.com>
In-Reply-To: <af570068c8bd25f207dd3a43b8acd7cf645b21af.1256314995.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What do you think about the rework of this atmel-mci DMA interface ?
patches:
[PATCH 1/3 v2] atmel-mci: change use of dma slave interface
[PATCH 2/3 v2] mmc: atmel-mci: New MCI2 module support in atmel-mci driver

We may consider them in replacement of the previous ones and dissociate 
this series from the third one which will be reworked and may goes through 
using another path.
(for the record: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc 
driver in at91sam9g45 chip and board).

Thanks,

Bye,
-- 
Nicolas Ferre

