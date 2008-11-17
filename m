Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYKQPO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYKQPO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYKQPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:14:19 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53136 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYKQPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:14:19 -0500
Message-Id: <1226934858.27080.1285213657@webmail.messagingengine.com>
X-Sasl-Enc: TxtwEuvFHyOfHrKVINVLaH0ui1EWnPiDw6llt6DcgKtT 1226934858
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
 <20081117094740.GK28786@elte.hu>
Subject: Re: [PATCH] trivial, entry_64: remove whitespace at end of lines
In-Reply-To: <20081117094740.GK28786@elte.hu>
Date: Mon, 17 Nov 2008 16:14:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008 10:47:40 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > All blame goes to: color white,red "[^[:graph:]]+$"
> > in .nanorc ;).
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > ---
> >  arch/x86/kernel/entry_64.S |  200 ++++++++++++++++++++++----------------------
> >  1 files changed, 100 insertions(+), 100 deletions(-)
> 
> applied to tip/x86/cleanups, thanks Alexander. This file still has a 
> horrible code structure but now at least our eyes do not burn out when 
> looking at it ;-)
> 
> 	Ingo

Lots of thanks!

Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

