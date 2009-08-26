Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZHZJZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZHZJZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZHZJZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:25:46 -0400
Received: from mail.atmel.fr ([81.80.104.162]:57911 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbZHZJZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:25:45 -0400
Message-ID: <4A94FF89.3000402@atmel.com>
Date: Wed, 26 Aug 2009 11:25:29 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ulf Samuelsson <ulf.samuelsson@atmel.com>
CC: Robert Emanuele <rob@emanuele.us>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: ARM Git Tree (at91sam9g45 patches)
References: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com><0F5F73E36031FD46AD3F2E6948F0C0A00188E074@frimb01.corp.atmel.com>	<9f53b4330908252124n168bd094k84f2691ec1a0a0ea@mail.gmail.com> <9E4512BFD9E74B73A1118E4B0EDE04E9@aeglos>
In-Reply-To: <9E4512BFD9E74B73A1118E4B0EDE04E9@aeglos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf Samuelsson :
 > Another important fix is that the AT91bootstrap provides a
> working Rom Code Replacement.bin.
> The one that has been on the Atmel home page is (was) broken.
> I pointed this out last week so they may have changed it by now.

Yes it is available now here (take the _13 revision):
http://www.atmel.com/dyn/resources/prod_documents/AT91SAM9G45_RomCode_Replacement_13.zip

Related documentation is here:
"Errata on AT91SAM9G45 Engineering Sample Devices Errata"
http://www.atmel.com/dyn/resources/prod_documents/doc6485.pdf

Note that all this is not needed with final releases of this chip (not
-ES marking).

Best regards,
-- 
Nicolas Ferre

