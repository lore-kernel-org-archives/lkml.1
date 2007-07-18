Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXGRM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXGRM1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXGRM10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:27:26 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:47518 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755851AbXGRM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:27:25 -0400
X-YMail-OSG: IUuooQQVM1nZwXuuEFrzSdLXZpn9X23O5V2EDOYO.2Isn7dfQX0TCtKBdJbSwYlpgfB683EzHA5TVCd4d2miiOZPgg--
X-RocketYMMF: knobi.rm
Date: Wed, 18 Jul 2007 05:27:24 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: [PATCH 00/17] per device dirty throttling -v7
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <845062.33459.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:

>> Latest version of the per bdi dirty throttling patches.
>>
>> Most of the changes since last time are little cleanups and more
>> detail in the split out of the floating proportion into their
>> own little lib.
>>
>> Patches are against 2.6.22-rc4-mm2
>>
>> A rollup of all this against 2.6.21 is available here:
>>
http://programming.kicks-ass.net/kernel-patches/balance_dirty_pages/2.6.21-per_bdi_dirty_pages.patch
>>
>> This patch-set passes the starve an USB stick test..
>
>I've done some testing of several problem cases.

 just curious - what are the plans towards inclusion in mainline?

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
