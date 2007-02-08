Return-Path: <linux-kernel-owner+w=401wt.eu-S1423102AbXBHPvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423102AbXBHPvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423100AbXBHPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:51:42 -0500
Received: from oceanic.wsisiz.edu.pl ([213.135.44.33]:13428 "EHLO
	oceanic.wsisiz.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423092AbXBHPvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:51:41 -0500
X-DKIM: Sendmail DKIM Filter v0.5.2 oceanic.wsisiz.edu.pl 37C2E1541E9
X-DomainKeys: Sendmail DomainKeys Filter v0.4.1 oceanic.wsisiz.edu.pl 37C2E1541E9
DomainKey-Signature: a=rsa-sha1; s=dkimtest; d=wsisiz.edu.pl; c=nofws; q=dns;
	b=UPpCZ0buCox7KyKySLb2SEoMB+xHwhVwWRd4FVXL1OGnGsguEBTiJa0myWFHlcXV4
	HJARkH1FsK9fXMTOM4LWBg4s68onWnXufRRDbsVFdHL53QIN5Xferk61A7Y3v6sXyHr
	0UU3VVN+Naoa5ONEWZP/PURpayFv/wYNbERyqgA=
X-DKIM: Sendmail DKIM Filter v0.5.2 oceanic.wsisiz.edu.pl A0D391541D1
X-DomainKeys: Sendmail DomainKeys Filter v0.4.1 oceanic.wsisiz.edu.pl A0D391541D1
Date: Thu, 8 Feb 2007 16:51:36 +0100 (CET)
From: Lukasz Trabinski <lukasz@wsisiz.edu.pl>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
In-Reply-To: <20070207204745.a2640c43.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081647290.5038@oceanic.wsisiz.edu.pl>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
 <20070207204745.a2640c43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Andrew Morton wrote:

> On Thu, 8 Feb 2007 00:02:10 +0100 (CET) Lukasz Trabinski <lukasz@wsisiz.edu.pl> wrote:
>
>> Hello
>>
>> On 2.6.19 I had about 60 days uptime, on 2.6.20 2 days :(
>>
>
> Did the machine actually fail?  Or did it just print these messages and
> keep going?

Was message from tg3 network driver, but i don't remember it. :(
Machine was totaly locked, only ctrl sysrq boot...

-- 
£T

