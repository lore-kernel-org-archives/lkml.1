Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbXKUIcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbXKUIcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXKUIcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:32:15 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:51935 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXKUIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:32:14 -0500
Message-ID: <4743EC56.1050304@selhorst.net>
Date: Wed, 21 Nov 2007 09:29:10 +0100
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, Kylene Jo Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] TPM TIS device driver locality request
References: <4740CBA3.4090708@selhorst.net> <20071119222308.05d32ba7.akpm@linux-foundation.org>
In-Reply-To: <20071119222308.05d32ba7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.1-5; AVE: 7.6.0.34; VDF: 7.0.0.240; host: mail)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> tpm_tis 00:0a: 1.2 TPM (device-id 0xFFFF, rev-id 255)
>> But correct is:
>> tpm_tis 00:0c: 1.2 TPM (device-id 0x3203, rev-id 9)
>> This short patch fixes this issue.
> Is this bug sufficiently serious to warrant inclusion of the fix in
> 2.6.24?  2.6.23.x?

I think including the patch for 2.6.24 is enough.

> Your email client is converting tabs to spaces.
> http://mbligh.org/linuxdocs/Email/Clients/Thunderbird has help for this.

Thanks for the hint,

Best regards,
Marcel Selhorst
