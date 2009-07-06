Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbZGFQg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbZGFQg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGFQgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:36:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46452 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387AbZGFQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:36:50 -0400
Date: Mon, 6 Jul 2009 17:37:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc tty layer instabilities
Message-ID: <20090706173749.2574114b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090706154054.7755e07b@lxorguk.ukuu.org.uk>
References: <200907061343.n66DhDbC004009@pilspetsen.it.uu.se>
	<20090706154054.7755e07b@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This happens perhaps once every 5 or so reboots. I haven't yet seen
> > any specific usage pattern that might be the trigger.
> 
> I suspect its simply a matter of timing randomness.
> 
> Does this help:

On second thought don't bother - this won't work so isn't worth testing
