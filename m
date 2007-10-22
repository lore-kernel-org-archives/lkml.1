Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXJVT7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXJVT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbXJVT7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:59:33 -0400
Received: from smtp1.int-evry.fr ([157.159.10.44]:36921 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXJVT7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:59:32 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Mon, 22 Oct 2007 21:59:31 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710181551.24912.florian.fainelli@telecomint.eu> <200710191401.56916.florian.fainelli@telecomint.eu> <20071022151845.5874fba3@ephemeral>
In-Reply-To: <20071022151845.5874fba3@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710222159.33014.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

Le lundi 22 octobre 2007, Andres Salomon a écrit :
> How does being used on MIPS and ARM make it suitable for x86?  If
> you're arguing that other x86 platforms conform to it, and it might be
> useful for them; sure, I'll buy that.  That doesn't seem to currently be
> the case, though.

The purpose of the API, as defines itself is meant to be generic and 
architecture neutral, and the few functions it defines are.

Since I needed some GPIO helpers for the RDC R-321x SoC, I picked up this one. 
Now if you want to propose another one go ahead, and I will rebase my code on 
top of yours.
-- 
Cordialement, Florian Fainelli
------------------------------
