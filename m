Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbXFWPWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbXFWPWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXFWPW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:22:29 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:54785 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbXFWPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:22:28 -0400
In-Reply-To: <20070623135721.GP23017@stusta.de>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <20070623131355.GO23017@stusta.de> <20070623134126.GN19904@flower.upol.cz> <20070623135721.GP23017@stusta.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <24d2cc09345acf3fec4393fe7cef7a62@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Denis Cheng <crquan@gmail.com>, Oleg Verych <olecom@flower.upol.cz>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Date: Sat, 23 Jun 2007 17:21:59 +0200
To: Adrian Bunk <bunk@stusta.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> gcc is a C compiler and claims to follow the C standard.

Not with the options the kernel build uses.  But, close
enough -- the differences are really minor stuff.


Segher

