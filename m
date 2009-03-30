Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZC3Txp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZC3Txp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZC3Txf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:53:35 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:39346 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZC3Txf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:53:35 -0400
From: Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29: Error during update of the kernel configuration.
Date: Mon, 30 Mar 2009 21:52:32 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903302152.32614.schmto@hrz.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 489ffd0e04f7de08dacf4c0626a7b16e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Mon, Mar 30, 2009 at 08:59:54PM +0200, Torsten Schmidt wrote:
>> I am not quit sure if this should be reported here: After loading the new 
>> kernel 2.6.29, the following error appears:
>> 
>> # make defconfig
>> *** Default configuration is based on 'i386_defconfig'
>> usr/Kconfig:145:warning: defaults for choice values not supported
>> #
>> # configuration written to .config
>> #
>> 
>> # make
>> scripts/kconfig/conf -s arch/x86/Kconfig
>> usr/Kconfig:145:warning: defaults for choice values not supported
>> 
>> *** Error during update of the kernel configuration.
>> 
>> make[2]: *** [silentoldconfig] Fehler 1
>> make[1]: *** [silentoldconfig] Fehler 2
>> make: *** [include/config/auto.conf] Fehler 2
>> 
>> Whats going wrong ?
>
>Running 'make oldconfig' should help.
>
>Daniel

No. Same error 

Torsten
