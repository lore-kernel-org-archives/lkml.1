Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbYEGCOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbYEGCOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYEGCOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:14:11 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:58754 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYEGCOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:14:09 -0400
Message-ID: <48211089.7000406@keyaccess.nl>
Date: Wed, 07 May 2008 04:14:33 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
References: <481FAC37.6090703@keyaccess.nl> <481FAD12.3030409@keyaccess.nl> <481FAF83.5090305@keyaccess.nl> <200805061308.14673.bjorn.helgaas@hp.com> <4820C846.2040205@keyaccess.nl>
In-Reply-To: <4820C846.2040205@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 23:06, Rene Herman wrote:

> Yes. Will regenerate against current mainline. My ISA test machine is 
> chugging away on things at the moment. Will repost when it's done.

Ofcourse, on .26-rc1 nothing actually works anymore. One of its 1643 other 
regressions is getting in the way I presume. It's quite impossible to test 
-rc1 kernels on something that actually takes some time to do so...

And especially .26-rc1. Anyways, will need some time. Can also not test your 
dynamic resource code on that machine until then.

Rene.

