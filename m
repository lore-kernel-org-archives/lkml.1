Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbZKDQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbZKDQw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZKDQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:52:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55255 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756516AbZKDQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:52:28 -0500
Date: Wed, 4 Nov 2009 16:54:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-14?B?TeVucyBSdWxs?= =?ISO-8859-14?B?Z+VyZA==?= 
	<mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
Message-ID: <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0911041710530.2927@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<1257103201.2865.6.camel@chumley>
	<yw1xy6mq0z2s.fsf@unicorn.mansr.com>
	<alpine.OSX.1.10.0911011540400.53392@caridad.local>
	<20091102000147.424f104b@lxorguk.ukuu.org.uk>
	<alpine.OSX.1.10.0911012023020.55434@caridad.local>
	<Pine.LNX.4.64.0911041710530.2927@artax.karlin.mff.cuni.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - With Linux package managers, the user is stuck with the software and 
>   version shipped by the distribution. If he wants to install anything 
>   newer or older, it turns into black magic and the typical desktop user 
>   (non-hacker) can't do it.

In the rpm/yumworld that would be "yum downgrade" and "yum upgrade" for
packages or whatever button on whatever gui wrapper you happen to have.

And of course yum supports third party repositories so you can also deal
with the updating problem which Windows tends not to do well for third
party software.

Installing it is the easy bit, keeping it current and secure is the fun
bit.

All pretty routine stuff and a lot of users add other repositories
themselves: generally by having a package that adds the repository, so
you just have one package to click on in a web browser and open, then off
it all goes.

