Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbXF2VGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbXF2VGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXF2VGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:06:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbXF2VGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:06:01 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Please release a stable kernel Linux 3.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Reply-To: 7eggert@gmx.de
Date: Fri, 29 Jun 2007 23:05:46 +0200
References: <8AH0j-3Qc-11@gated-at.bofh.it> <8AH0j-3Qc-9@gated-at.bofh.it> <8B0vZ-r6-5@gated-at.bofh.it> <8B46G-69z-15@gated-at.bofh.it> <8B52G-7C9-5@gated-at.bofh.it> <8BalK-7Ic-39@gated-at.bofh.it> <8BaYr-8tJ-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I4Nf0-00016f-9A@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/mDr3tkFLnjtX2JhCRwiHvqEOka6Sxyt4h3hr
 blmdQ5CDo5t2Kcq0vw+QB4dIFjcGFeNlp5G8dKPox2yvIrC9Vv
 979Ow++nBEpOsErRxkaUA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 29 Jun 2007 00:00:27 +0200
> Rene Herman <rene.herman@gmail.com> wrote:
>> On 06/28/2007 06:30 PM, Alan Cox wrote:

>> > Public domain is GPL compatible.
>> 
>> Would you happen to have an opinion on the attached? I don't so much need it
> 
> The answer is "NO!!!!"
> 
> Public domain also means "I don't have to give you the source".
> If its merged with the kernel the resulting work is GPL anyway
> 
>> Stating that code which one intends to be in the public domain has "GPL and
>> additional rights" is a bit of a travesty though.
> 
> Indeed if its public domain you may have almost no rights at all
> depending what you were given. Once you get the source code you can do
> stuff but I don't have to give you that. If its public domain I can find
> security holes in it, and refuse to provide the fixed module in source
> form even.

The GPL forces nobody to not release his module under PD, therefore it can't
protect you from that. Even minor changes - like adjusting the module to use
to the current API - won't change that, at least in Germany they'd have to
qualify as a work of their own in order to create a GPL-only derived work,
because anything not qualifying for that could also be integrated into the
PD version, and both would remain identical.
-- 
"Cluster bombing from B-52s is very, very accurate. The bombs are
guaranteed to always hit the ground."
-U.S.A.F. Ammo Troop
Friﬂ, Spammer: 8wfPvrtu@j0o.7eggert.dyndns.org r@2ypKo.7eggert.dyndns.org
