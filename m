Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZIETsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZIETsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 15:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZIETsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 15:48:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZIETsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 15:48:03 -0400
From: Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Sat, 5 Sep 2009 21:08:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-pcmcia@lists.infradead.org, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909040149.45066.christian@kraemer-eu.de> <20090905135911.GC3171@pengutronix.de>
In-Reply-To: <20090905135911.GC3171@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909052108.39225.christian@kraemer-eu.de>
X-Provags-ID: V01U2FsdGVkX19jackwCxKjXAkasXH1bUJ7OgJJ3Ll+WqPJYwO
 HKb1fOVwTjRJhCB0ryVSXReZI1j6hBfiP6HvyPtJa4gY6UNI0n
 jA/Qx1syamExyl7Qeu1YzDbd/EsVPf1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 September 2009 15:59:11 Wolfram Sang wrote:
> > For this laptop at all there are a lot of problems with newer linux
> > kernels. Some people got it working with serveral hacks in the config
> > file of the pcmcia_cs suite, but all those tips only fit with pcmcia_cs
> > and so to the 2.4 kernel. If you're interessted in those sources, i could
> > search the URLs again in my browser history.
>
> Yes, maybe those explain the problem; that would definately help ;)

Okay, here are the urls i found some hacks for this model:
http://www.krumeich.de/download/tp600/config.opts
http://www.cs.cmu.edu/~jcl/linux/thinkpad_600.html
http://www.faqs.org/docs/Linux-HOWTO/PCMCIA-HOWTO.html
