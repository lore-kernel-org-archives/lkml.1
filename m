Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYHWGVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYHWGVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 02:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYHWGVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 02:21:22 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:43904 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYHWGVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 02:21:22 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: rdc321x: remove unused #include <version.h>
Date: Sat, 23 Aug 2008 08:21:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080823130903.126E.WEIYI.HUANG@gmail.com>
In-Reply-To: <20080823130903.126E.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808230821.03258.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1471D3F094D.23FA2
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang.

Le Saturday 23 August 2008 07:56:09 Huang Weiyi, vous avez écrit :
> The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
>   arch/x86/mach-rdc321x/platform.c
>
> This patch removes the said #include <version.h>.
>
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Acked-by: Florian Fainelli <florian.fainelli@telecomint.eu>
