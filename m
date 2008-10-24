Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYJXRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYJXRjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJXRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:39:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbYJXRjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:39:02 -0400
Date: Fri, 24 Oct 2008 15:38:51 -0200
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
Subject: Re: [PATCH 7/7] adding common used headers
Message-ID: <20081024153851.2ac45313@pedra.chehab.org>
In-Reply-To: <d9def9db0810221413s152f6fa7s21caffbfa3fa5712@mail.gmail.com>
References: <d9def9db0810221413s152f6fa7s21caffbfa3fa5712@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 23:13:20 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

>     adding common used headers
> 
>     tunerchip.h:
>     just contains an internal used struct which can be used for
> setting up a tuner frontend.

NACK.

This seems to be some binding for your em28xx. It is currently not needed.

Cheers,
Mauro
