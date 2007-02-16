Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbXBQM2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbXBQM2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXBQM2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:28:14 -0500
Received: from c8fc80ce.bsb.virtua.com.br ([200.252.128.206]:61643 "EHLO
	areia.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450AbXBQM2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:28:13 -0500
X-Greylist: delayed 4999 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Feb 2007 07:28:13 EST
Subject: Re: [PATCH 000/196] V4L/DVB updates
From: Mauro Carvalho Chehab <mchehab@linuxtv.org>
To: Georgi Chorbadzhiyski <gf@unixsol.org>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <45D4E73A.4060005@unixsol.org>
References: <1171519195.6703.25.camel@areia>  <45D4E73A.4060005@unixsol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Feb 2007 08:20:33 -0200
Message-Id: <1171621233.6316.45.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sex, 2007-02-16 às 01:05 +0200, Georgi Chorbadzhiyski escreveu:
> Mauro Carvalho Chehab wrote:
> > Basically, this series adds support for a bunch of newer cards and newer
> > drivers, do some relevant cleanups on cx88 (improving source code 
> > readability and reducing binary code size), adds FM radio support on
> > pvrusb2 and do several other fixes and improvements.
> 
> Hi, what is the status of Mantis driver for Twinhham DVB-S cards
> and support for their CAM interface?

I think Manu is working on that. I don't have any status about this.

If you have any specific questions about DVB hardware, the best would be
to use linux-dvb@linuxtv.org Mailing List. This is a subscribers-only
list. If you are interested, you can subscribe via mailman web interface
at http://linuxtv.org.

Cheers,
Mauro.
