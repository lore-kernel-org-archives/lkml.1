Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYEZQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYEZQRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYEZQQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:16:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59868 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYEZQQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:16:46 -0400
Date: Mon, 26 May 2008 18:16:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Mikael Pettersson <mikpe@it.uu.se>,
       =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug'
 is passed.
In-Reply-To: <871w3pw195.fsf@saeurebad.de>
Message-ID: <alpine.LNX.1.10.0805261813180.19084@fbirervta.pbzchgretzou.qr>
References: <1211687267-12962-1-git-send-email-krh@redhat.com> <18490.33106.357734.800133@harpo.it.uu.se> <alpine.LNX.1.10.0805261607090.19084@fbirervta.pbzchgretzou.qr> <871w3pw195.fsf@saeurebad.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-26 17:09, Johannes Weiner wrote:
>>
>> In fact, quite the opposite, http://tinyurl.com/68notu , is
>> worthwhile.
>
>I want dots!  My bootloader already prints dots!
>
>Decompressing Linux...................done.
>Booting the kernel.

I have deliberately chosen stars instead of dots because the rest of
the kernel already uses dots here and there without actually
implementing a progress "bar" ("Foobaring your CPU...",wait,"done\n") to
stand out a bit, but I do not actually mind what is printed, whether
it is stars, dots or ▒s.
