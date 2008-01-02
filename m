Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYABMPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYABMPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYABMPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:15:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYABMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:15:45 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: macro _set_base - "do - while(0)" question
To: Abdel <draconux@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 02 Jan 2008 13:15:33 +0100
References: <9HagT-66H-21@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JA2VS-0000eS-DV@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX193ObQBHVN4qYYT78G4ESqR95+8SwFvE00YMsi
 ubrIQFF6wthXDoWwb1qEk4YR2FD2WIVNLuaMQTHoQwvzyn6agj
 St6aabijbHNQVMzAXm4Dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abdel <draconux@gmail.com> wrote:

> In file include/asm-i386/system.h,  _set_base and _set_limit use an
> useless do ... while(0)
> 
> Why is this needed ?

http://kernelnewbies.org/FAQ/DoWhile0

