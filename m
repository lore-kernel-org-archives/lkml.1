Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYAXRLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYAXRLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYAXRL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:11:26 -0500
Received: from khc.piap.pl ([195.187.100.11]:55250 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYAXRLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:11:25 -0500
To: Marcin Gil <marcin.gil@gmail.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: JMicron PATA 2.6.24-rc7 can't find drives
References: <200801232323.36187.marcin.gil@gmail.com>
	<20080123234639.025cc859@lxorguk.ukuu.org.uk>
	<479839B4.3060202@gmail.com>
	<20080124142717.GA16173@csclub.uwaterloo.ca>
	<4798A114.6010803@gmail.com>
	<20080124144359.GD16171@csclub.uwaterloo.ca>
	<4798A537.9000104@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 Jan 2008 18:11:22 +0100
In-Reply-To: <4798A537.9000104@gmail.com> (Marcin Gil's message of "Thu\, 24 Jan 2008 15\:48\:23 +0100")
Message-ID: <m3abmvtah1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Gil <marcin.gil@gmail.com> writes:

> +-----+-----+
> mobo  hdd   dvd
>
> I think that cable select would take dvd as master and hdd as slave.
> This was not preferable when hdd was my primary drive. I can try
> cable-select now since I boot off new SATA drive.

Is a master in the middle permitted by the specs at all?
-- 
Krzysztof Halasa
