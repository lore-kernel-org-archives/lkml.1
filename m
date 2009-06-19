Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZFSTdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZFSTdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZFSTc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:32:58 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:41808 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZFSTc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:32:57 -0400
Message-ID: <4A3BE7EA.4050800@msgid.tls.msk.ru>
Date: Fri, 19 Jun 2009 23:32:58 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: ronis@ronispc.chem.mcgill.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: Panic booting 2.6.30
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
In-Reply-To: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ronis wrote:
> I've just upgraded an older machine (a P3 running slackware 11.0) from
> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
> lilo) I get:
> 
> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
> Please append a correct root= boot option; here are the available
> partions:     <====== nothing shows here...
> Kernel-Panic - not syncing.
> 
> I had rebooted with and without root=hda2.   The old kernel is still
> usable.
> 
> Lilo.conf looks like:

Add large-memory option to lilo.conf

/mjt
