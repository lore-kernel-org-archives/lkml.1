Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbYDANsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbYDANsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYDANsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:48:32 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:57522 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbYDANsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:48:31 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] mips: remove MIPS_XXS1500
Date: Tue, 1 Apr 2008 15:54:02 +0200
User-Agent: KMail/1.9.9
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <20080330224025.GF28445@cs181133002.pp.htv.fi>
In-Reply-To: <20080330224025.GF28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200804011554.03249.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Le lundi 31 mars 2008, Adrian Bunk a écrit :
> MIPS_XXS1500 has several compile problems like e.g. the
> #include <asm/keyboard.h> in arch/mips/au1000/xxs1500/board_setup.c
> having been broken by the removal of this header back in February 2004.

Nack, just emailed you with the fix.
