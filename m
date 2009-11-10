Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbZKJNRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbZKJNRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZKJNRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:17:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53726 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbZKJNRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:17:15 -0500
Date: Tue, 10 Nov 2009 13:19:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: weigelt@metux.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091110131907.4a6bfc73@lxorguk.ukuu.org.uk>
In-Reply-To: <20091110130050.GA6555@nibiru.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911021057450.464@caridad.icculuslan>
	<20091110112737.GB2998@nibiru.local>
	<1257856825.795.20.camel@tara.firmix.at>
	<20091110130050.GA6555@nibiru.local>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Or implement running 32bit plugins from a 64bit browser.
> 
> And land in an nightmare: you have to create an kind of in-process jail, 
> so all referenced 32bit lib references get properly emulated.

You instead want them out of process. Something that most distributions
seem to have managed.

http://gwenole.beauchesne.info//en/projects/nspluginwrapper

Alan
