Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZFDIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZFDIc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFDIcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:32:21 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64891 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZFDIcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:32:20 -0400
Message-ID: <4A278686.9090702@atmel.com>
Date: Thu, 04 Jun 2009 10:32:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] at91: Support for at91sam9g45: clocks management
References: <1244105282-31456-1-git-send-email-nicolas.ferre@atmel.com> <1244105282-31456-2-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244105282-31456-2-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre :
> Add the at91sam9g45 series support to the AT91 generic clock file.
> This takes care of the particularities of the PMC for this series.
> It also takes advantage of the management by functionalities of
> those PLLs and clocks.

I must have included in the previous message that the
patch 5438/1 (Applied) is supposed applied on top of current linus' git
tree before this series.

Best regards,
-- 
Nicolas Ferre

