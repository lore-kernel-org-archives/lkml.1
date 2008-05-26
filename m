Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYEZPKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYEZPKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYEZPKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:10:03 -0400
Received: from saeurebad.de ([85.214.36.134]:49651 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYEZPKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:10:01 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Kristian =?utf-8?Q?H=C3=B8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug' is passed.
References: <1211687267-12962-1-git-send-email-krh@redhat.com>
	<18490.33106.357734.800133@harpo.it.uu.se>
	<alpine.LNX.1.10.0805261607090.19084@fbirervta.pbzchgretzou.qr>
Date: Mon, 26 May 2008 17:09:26 +0200
In-Reply-To: <alpine.LNX.1.10.0805261607090.19084@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Mon, 26 May 2008 16:09:11 +0200 (CEST)")
Message-ID: <871w3pw195.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jan Engelhardt <jengelh@medozas.de> writes:

> On Monday 2008-05-26 11:22, Mikael Pettersson wrote:
>>=?utf-8?q?Kristian=20H=C3=B8gsberg?= writes:
>> > Signed-off-by: Kristian HÃ¸gsberg <krh@redhat.com>
>> > ---
>> > 
>> > Updated to use the standard 'debug' parameter instead of 'noisy'.
>> > 
>> >  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
>> >  1 files changed, 27 insertions(+), 3 deletions(-)
>>
>>NAK
>>
>>You still haven't explained why suppressing these
>>messages is necessary.
>
> In fact, quite the opposite, http://tinyurl.com/68notu , is
> worthwhile.

I want dots!  My bootloader already prints dots!

Decompressing Linux...................done.
Booting the kernel.

	Hannes
