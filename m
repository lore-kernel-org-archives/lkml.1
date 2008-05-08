Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbYEHJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbYEHJWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYEHJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:22:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39676
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbYEHJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:21:59 -0400
Date: Thu, 08 May 2008 02:21:53 -0700 (PDT)
Message-Id: <20080508.022153.227475944.davem@davemloft.net>
To: jengelh@medozas.de
Cc: linux-kernel@vger.kernel.org, adaplas@pol.net, hpa@zytor.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.26-rcX VC console scrolling regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0805081049510.16904@fbirervta.pbzchgretzou.qr>
References: <20080507.214637.193700986.davem@davemloft.net>
	<alpine.LNX.1.10.0805081049510.16904@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 8 May 2008 11:13:37 +0200 (CEST)

> 
> On Thursday 2008-05-08 06:46, David Miller wrote:
> >
> >Causes garbage characters to appear at the end of lines on my VCs when
> >scrolling.
> >
> >They look like lowercase 'c' characters with a '.' above them, and they
> >are colored light blue.  The rest of the console text is fine.
> 
> i386 or sparc64?

sparc64.

> Are you using a serial console?

:-/  No, why would I report a VC console output bug if I were
using a serial console?
