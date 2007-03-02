Return-Path: <linux-kernel-owner+w=401wt.eu-S1422995AbXCBJ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422995AbXCBJ6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422996AbXCBJ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:58:38 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:46680 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422995AbXCBJ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:58:37 -0500
Message-ID: <45E7F55F.6090807@gmail.com>
Date: Fri, 02 Mar 2007 10:58:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Werner LEMBERG <wl@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: Memory stick reader Ricoh R5C592 supported?
References: <20070302.102351.146595518.wl@gnu.org> <45E7F13E.60408@drzeus.cx>
In-Reply-To: <45E7F13E.60408@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman napsal(a):
> Werner LEMBERG wrote:
>> Folks,
>>
>>
>> my Dell Inspiron 6400 laptop has both a Ricoh R5C822 host adapter (for
>> SD, MMC, etc.) and a Ricoh R5C592 host adapter for memory sticks.
>>
>> While the former works just fine, it seems to me that the latter
>> hasn't any support.  Indeed, inserting a Sony MSA-128A memory stick
>> causes no reaction whatsoever.  Searching with google, I haven't found
>> anything related to this chip; looking into the kernel source code
>> wasn't successful either.
>>
>> Can you please shed some light on the current situation?  I'm using
>> kernel 2.6.20.
>>
> 
> Memory stick is completely unsupported. We haven't got any specs for neither the
> the host controllers or the protocol. So I would guess it would be quite some
> time before memorystick is supported directly by Linux.

There is an experimental out-of-the-tree ricoh driver. I don't know if your 
reader is supported, you can give it a try and report back. Make sure, you have 
backed your data up.
http://marc.theaimsgroup.com/?l=linux-kernel&m=117123096427193&w=2

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
