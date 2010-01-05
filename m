Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803Ab0AEQdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0AEQdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615Ab0AEQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:33:49 -0500
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:53263 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754508Ab0AEQdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:33:49 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 11:33:46 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902089268@mi8nycmail19.Mi8.com>
In-Reply-To: <4B420C06.3080402@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
Thread-Index: AcqNVFXed/KwvjKoSX6grS392IHEXgA0A1Kw
References: <BD79186B4FD85F4B8E60E381CAEE19090200F669@mi8nycmail19.Mi8.com> <4B420C06.3080402@redhat.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Peter Jones" <pjones@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Jan 2010 16:33:47.0213 (UTC) FILETIME=[DAABA7D0:01CA8E24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o05GYa16008135

On Monday, January 04, 2010 8:41 AM, Peter Jones wrote:
> On 12/30/2009 02:49 PM, H Hartley Sweeten wrote:
>> Use the %pM kernel extension to display the MAC address.
>> 
>> Also, remove the 'mac' variable and use nic->mac directly.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Peter Jones <pjones@redhat.com>
>
> Looks good to me.
>
> Acked-by: Peter Jones <pjones@redhat.com>

Hello Peter,

Will you be merging this?

I sent a number of similar patches to the netdev list.  David Miller
had merge issues with them due to a whitespace problem at the end of
the patches.  I have figure out the issue and am reposting the patch
series now.  If you have not merged this I will fix this one also and
send it to him with the others.

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
