Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbXITGxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbXITGxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXITGxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:53:33 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57957 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750786AbXITGxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:53:32 -0400
Date: Thu, 20 Sep 2007 08:53:23 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@avr32linux.org, avr32@atmel.com
Subject: Re: [PATCH] AVR32:  Drop support for redundant "keepinitrd"
 boot-time parm.
Message-ID: <20070920085323.74676fc9@dhcp-255-175.norway.atmel.com>
In-Reply-To: <Pine.LNX.4.64.0709190840020.20641@localhost.localdomain>
References: <Pine.LNX.4.64.0709190840020.20641@localhost.localdomain>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 08:43:42 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Given the existing "retain_initrd" boot-time parameter defined in
> init/initramfs.c, there appears to be no need for the equivalent
> "keepinitrd" parameter.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Applied, thanks.

If anyone are actually using the "keepinitrd" option on AVR32 (I doubt
it since you have to read the source to know that it even exists),
please use "retain_initrd" instead.

Håvard
