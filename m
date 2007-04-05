Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbXDEAJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbXDEAJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXDEAJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:09:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46693 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXDEAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:09:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46143DE4.1010708@s5r6.in-berlin.de>
Date: Thu, 05 Apr 2007 02:08:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070303 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Rene Herman <rene.herman@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet> <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com> <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <s5hps6kxefx.wl%tiwai@suse.de> <20070404174839.GQ27660@stusta.de> <4613E7FB.20601@gmail.com> <20070404191258.GR27660@stusta.de>
In-Reply-To: <20070404191258.GR27660@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Realistically, users should report problems with vendor kernels to the 
> vendor and problems with ftp.kernel.org kernels to either linux-kernel 
> or the kernel Bugzilla, and forwarding issues to the responsible people 
> (if any) should be done there [1].
> 
>> Rene.
> 
> cu
> Adrian
> 
> [1] Andrew is doing this

At bugzilla.kernel.org, driver maintainers can also watch the respective
subsystem maintainer's address or subsystem's meta address to get
notified when a bug is being filed under a subsystem.
-- 
Stefan Richter
-=====-=-=== -=-- --=-=
http://arcgraph.de/sr/
