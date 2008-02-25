Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYBYLDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYBYLDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYBYLD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:03:26 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:48427 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYBYLDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:03:25 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add rdc321x defconfig file
Date: Mon, 25 Feb 2008 12:03:25 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <200802251124.17561.florian.fainelli@telecomint.eu> <20080225105110.GA5648@elte.hu>
In-Reply-To: <20080225105110.GA5648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802251203.27433.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Le lundi 25 février 2008, Ingo Molnar a écrit :
> ok, great! Btw., do you think you could achieve your board to boot fine
> with CONFIG_X86_GENERICARCH=y and CONFIG_M486=y?

I think it can boot already, will tell you when I have done the necessary 
testing.
