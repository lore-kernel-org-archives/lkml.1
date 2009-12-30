Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZL3NAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZL3NAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZL3NAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:00:42 -0500
Received: from 62.1.125.199.dsl.dyn.forthnet.gr ([62.1.125.199]:38408 "EHLO
	poseidon.vergina.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbZL3NAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:00:42 -0500
Message-ID: <4B3B4EF6.7030800@asyr.hopto.org>
Date: Wed, 30 Dec 2009 15:00:38 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091229 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: gentoo-user@lists.gentoo.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SOLVED] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org> <200912301208.54359.dirk.heinrichs@online.de>
In-Reply-To: <200912301208.54359.dirk.heinrichs@online.de>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 12/30/2009 01:08 PM Dirk Heinrichs wrote the following:
> Am Mittwoch 30 Dezember 2009 11:49:39 schrieb Thanasis:
>
>> I have a netbook (Acer Aspire One A110L) and installed a 1GB DDR2 in the
>> available slot, for a total of 1.5GB or RAM.
>> The BIOS reports it as 1.5GB and so does grml linux (booting from usb),
>> but the installed gentoo linux reports only 904600 kB:
>
> With more than 1G of memory, you should set CONFIG_HIGHMEM4G=y.
>
> HTH...
>
> 	Dirk
That did it !
Thanks again.
:-)
