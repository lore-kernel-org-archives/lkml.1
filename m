Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZKJNEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZKJNEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZKJND7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:03:59 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:53544 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZKJND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:03:58 -0500
Date: Tue, 10 Nov 2009 14:00:50 +0100
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
Message-ID: <20091110130050.GA6555@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan> <20091110112737.GB2998@nibiru.local> <1257856825.795.20.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257856825.795.20.camel@tara.firmix.at>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernd Petrovitsch <bernd@firmix.at> wrote:

> > The root of evil are plugins - even worse: binary-only plugins.
> > 
> > Let's just take browsers: is there any damn good reason for not putting
> > those things into their own process (9P provides a fine IPC for that),
> > besides stupidity and lazyness of certain devs (yes, this explicitly
> > includes mozilla guys) ?
> Or implement running 32bit plugins from a 64bit browser.

And land in an nightmare: you have to create an kind of in-process jail, 
so all referenced 32bit lib references get properly emulated.

Better kickoff the whole idea of plugins at all.


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
