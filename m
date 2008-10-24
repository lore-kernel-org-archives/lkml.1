Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYJXRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYJXRhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYJXRhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:37:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYJXRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:37:18 -0400
Date: Fri, 24 Oct 2008 15:37:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
Subject: Re: [PATCH 4/7] adding sharp s921 ISDB-T driver
Message-ID: <20081024153709.26b5b33a@pedra.chehab.org>
In-Reply-To: <d9def9db0810221407v4800a7ecse3f56c2fa195336f@mail.gmail.com>
References: <d9def9db0810221407v4800a7ecse3f56c2fa195336f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 23:07:42 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

>     s921_module.c:
>     wrapper for the dvb frontend interface
>     s921_core.c:
>     core s921 1seg ISDB-T driver, everything is set to auto as much as possible
>     in order to not require certain parameters which currently cannot be passed
>     to the ISDB-T chip.
> 
>     ISDB-T support can be tested using dvbscan, dvbstream/snoop and mplayer
>     Tested 1seg H264/aac stream with this driver using a custom linux
> ISDB-T player

ACK.

Applied at the development tree.


Cheers,
Mauro
