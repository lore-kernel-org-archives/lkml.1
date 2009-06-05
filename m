Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZFEAy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZFEAy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZFEAyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:54:52 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:53098 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZFEAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q5SxRnE54TgQfOobe0Ha84WaTdj+gTL9IMEByono4m4M+/2zHp445omkt9lUgzMvWd
         sg2wnoSJ/FPVYTtlQhETSydsfo8wrR5wG76jrprPJKG80NaQAKozx6T4yu9v9xJ7NjQh
         8hAARSFoXwSfaMk3Mx8BIZ4eGin7ncGZkYFWk=
Message-ID: <4A286CDB.80708@gmail.com>
Date: Thu, 04 Jun 2009 18:54:51 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: Andi Kleen <andi@firstfloor.org>, Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041529.49997.lkml@morethan.org> <4A2867C1.90408@gmail.com> <200906041952.39569.lkml@morethan.org>
In-Reply-To: <200906041952.39569.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> VIA has not publicly published sufficient technical information to presume
> that the cache coherency control protocols are the same as Intel's.
> 
> These are cpu/chipset pairs - Think System On 2 Chips. SoS2C.

At the low level, maybe not, but functionally it has to be equivalent. 
Otherwise the chip can't really be considered x86-compatible.
