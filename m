Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYBQSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYBQSsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYBQSsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:48:43 -0500
Received: from www.tglx.de ([62.245.132.106]:56934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYBQSsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:48:42 -0500
Date: Sun, 17 Feb 2008 19:48:36 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
Message-ID: <20080217194836.3a8a3b97@bluebox.local>
In-Reply-To: <20080217072927.4b6c5964@laptopd505.fenrus.org>
References: <20080216225932.22460d31@dilbert.local>
	<20080216143946.6d532a41@laptopd505.fenrus.org>
	<20080217015453.2a4e4142@dilbert.local>
	<20080216182939.061c7246@laptopd505.fenrus.org>
	<20080217133753.661cd98d@bluebox.local>
	<20080217072927.4b6c5964@laptopd505.fenrus.org>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 17 Feb 2008 07:29:27 -0800
schrieb Arjan van de Ven <arjan@infradead.org>:

> On Sun, 17 Feb 2008 13:37:53 +0100
> "Hans J. Koch" <hjk@linutronix.de> wrote:
> > > Of course there's no driver for the wlan, but that's a different
> > > story ;)
> > 
> > I replaced that unsupported Atheros 5007 card with an ipw3945, so I
> > haven't got that problem.
> 
> oh but then you have a MUCH bigger problem ;(
> The bios of that animal is hardcoded to the 5007 (or at least
> Atheros). If you stick your own card in, for FCC reasons, the bios
> refuses the card. (this is not unique to Asus; all notebooks do this
> for cards they're not certified with. This apparently  has to do with
> the antenna being part of the laptop, and thus part of the radio in
> FCC speak)

Someone claims he's done it:

http://beta.ivancover.com/wiki/index.php/Eee_PC_Internal_Upgrades#Wifi

Hans
