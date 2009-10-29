Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZJ2Qdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZJ2Qdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZJ2Qdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:33:50 -0400
Received: from snt0-omc1-s28.snt0.hotmail.com ([65.55.90.39]:47252 "EHLO
	snt0-omc1-s28.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbZJ2Qdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:33:50 -0400
Message-ID: <SNT125-W40D0711CC6E5AC27159050C3B70@phx.gbl>
X-Originating-IP: [164.116.126.146]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <davej@redhat.com>
CC: <jengelh@medozas.de>, <macro@linux-mips.org>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.com>
Subject: RE: [X86] Fix up silly i1586 boot message.
Date: Thu, 29 Oct 2009 09:33:55 -0700
Importance: Normal
In-Reply-To: <20091028154650.GA13660@redhat.com>
References: <20080528165713.GA412@redhat.com>
 <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl>
 <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <SNT125-W471F856F2358A53E59A13BC3B80@phx.gbl>
 <alpine.LSU.2.00.0910280914590.28170@obet.zrqbmnf.qr>
X-OriginalArrivalTime: 29 Oct 2009 16:33:54.0882 (UTC) FILETIME=[9B26DA20:01CA58B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 <20091028154650.GA13660@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



>> So that tells us that either NT4 works=2C or nobody uses
>> NT4 on fam15s.
>
> Or that no-one cares.
NT 4 do work on fam15s=2C because 15 truncated to 3 bits is 7=2C while 8 tr=
uncated to 3 bits is 0.
> I don't know why this year and half old thread was resurrected=2C
> but can we all do our bit for lkml traffic reduction and let it die?
> (or at least drop me from the cc. The bug was fixed May 2008=2C
> there's no reason afaics for endless bibble filling everyones inbox).
=A0I know that this bug is now fixed=2C but=A0I wanted to provide more deta=
il on the history behind this.
Yuhong Bao 		 	   		 =20
_________________________________________________________________
Windows 7: Simplify your PC. Learn more.
http://www.microsoft.com/Windows/windows-7/default.aspx?ocid=3DPID24727::T:=
WLMTAGL:ON:WL:en-US:WWL_WIN_evergreen1:102009=
