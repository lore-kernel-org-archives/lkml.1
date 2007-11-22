Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbXKVSLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbXKVSLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXKVSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:11:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54124 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXKVSLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:11:34 -0500
Subject: Re: RTL2831U kernel driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kernel@beer.org.uk
Cc: linux-kernel@vger.kernel.org,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <40711.127.0.0.1.1195734828.squirrel@127.0.0.1>
References: <40711.127.0.0.1.1195734828.squirrel@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Nov 2007 16:11:21 -0200
Message-Id: <1195755081.4810.23.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qui, 2007-11-22 às 12:33 +0000, Vic escreveu:
> Hi All.
> 
> Sorry for the breach of netiquette - I'm not subscribed to the list
> (please CC: me on anything important!), but I'm not really up to much a s
> a kernel contributor...
> 
> Anyway - here's the reason for my posting. I've got a kernel driver for
> the RTL2831U device (a DVB-T device) from Realtek. Just this morning, I
> got an email from them agreeing to release it under GPL.
> 
> It currently has no copright notices at all

Kernel is GPLv2. So, the driver should be released under GPLv2 only or
GPLv2 or later.

>  - I think I should add Realtek attributions to it.

I would be better if someone from Realtek could send the driver. Anyway,
any driver submitted to kernel should be signed with a SOB. 

There's a guide on how to submit a driver to kernel. For convenience,
they are briefly summarized at
http://linuxtv.org/v4lwiki/index.php/How_to_submit_patches

> Then what should I do?

It would be nice if you can subscribe to Linux DVB mailing [1] list and
post the driver there. The list is open to users and to developers, so,
maybe it would be interesting for you to participate there.

[1] http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

If you are not willing to subscribe to DVB ML, please copy V4L/DVB
maintainers mailing list[2] on this subject. This list allows you to
post even not being a subscriber.

[2] v4l-dvb-maintainer@linuxtv.org

It is important to submit the driver either to DVB or V4L/DVB
maintainers ML, since this will allow all developers to take a look at
the driver, checking for eventual issues, and helping to improve it.
Several developers are not subscribed to LKML (or don't read it
regularly).
 
Cheers,
Mauro

