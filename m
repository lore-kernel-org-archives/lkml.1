Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYHLNaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYHLNaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYHLNa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:30:27 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49293 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYHLNa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:30:27 -0400
Message-ID: <48A19082.3030507@keyaccess.nl>
Date: Tue, 12 Aug 2008 15:30:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] WATCHDOG: don't auto-grab eurotechwdt.
References: <489E0F5A.8010404@keyaccess.nl> <20080812125840.GA13910@cs181140183.pp.htv.fi> <48A18C2C.3030009@keyaccess.nl> <20080812131850.GE13910@cs181140183.pp.htv.fi>
In-Reply-To: <20080812131850.GE13910@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-08-08 15:18, Adrian Bunk wrote:

>>> You are expecting randconfig kernels to boot?
>> 90% does it seems. Ingo has been using it as part of automated testing  
>> for some time now.
> 
> Please define "boot".

I can't since I'm not doing the testing, Ingo is. When you ask him, do 
take into account the inherent goodness of things that catch bugs...

> E.g. for your harddisk driver alone the probability of not having it 
> included in a randconfig kernel is definitely > 10%.
> 
> Same goes for the network driver.

I suppose he has local allrandom.config files.

Rene.
