Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYFEU5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYFEU5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYFEU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:57:40 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:40342 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750708AbYFEU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:57:39 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] PCI: Unhide the SMBus on the Compaq Evo D510
Date: Thu, 5 Jun 2008 13:57:37 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080604135331.3fb6f284@hyperion.delvare>
In-Reply-To: <20080604135331.3fb6f284@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051357.37434.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 04, 2008 4:53 am Jean Delvare wrote:
> One more machine with a hidden Intel SMBus. Unhiding it reveals a SMSC
> EMC6D100 hardware monitoring chip. I have checked that this machine
> has no ACPI magic touching the SMBus nor the hardware monitoring chip,
> so this should be safe.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> Patch already sent on:
>  * 2008-04-17

Thanks Jean, I'll queue it in linux-next.

Jesse
