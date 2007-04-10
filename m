Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXDJLne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXDJLne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXDJLne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:43:34 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:59342 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXDJLnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:43:33 -0400
Message-ID: <461B7855.9050500@gmail.com>
Date: Tue, 10 Apr 2007 13:43:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Char: cyclades, remove volatiles
References: <16309194841640222796@karneval.cz>	<25307199761334218148@karneval.cz>	<20070406171406.317ea28a.akpm@linux-foundation.org>	<46174825.4050509@gmail.com> <17946.19347.748203.428318@smtp.charter.net>
In-Reply-To: <17946.19347.748203.428318@smtp.charter.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 10 Apr 2007 13:43:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel napsal(a):
>>>>>> "Jiri" == Jiri Slaby <jirislaby@gmail.com> writes:
> 
> Jiri> Andrew Morton napsal(a):
>>> On Wed,  4 Apr 2007 23:45:38 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>>> cyclades, remove volatiles
>>> The other changes seem uncontroversial, but this one has the potential
>>> to change runtime behaviour.  And cyclades.c is a driver which some people
>>> actually use ;)
> 
> Jiri> Well, don't you know anybody with Z card, please?
> 
> I've got an old Cyclom-Y card (ISA) that I use, should I bother trying
> out your changes?

No, don't bother with these. If you are willing to test, please test next
patchset -- I'll post it shortly. Or do you prefer external patched module?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
