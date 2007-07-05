Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbXGESei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbXGESei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbXGESec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:34:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125AbXGESeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:34:31 -0400
Message-ID: <468D39B6.9060003@anagramm.de>
Date: Thu, 05 Jul 2007 20:34:30 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca> <468AA364.2010000@nortel.com> <468AB976.2010806@redhat.com> <200707041056.53992.u.luckas@road.de> <20070704165313.GC4306@sequoia.sous-sol.org> <468CFCA1.3080104@anagramm.de> <468D2EF1.7050908@nortel.com>
In-Reply-To: <468D2EF1.7050908@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+gvGcDNcYfskUuUJFHjRlWGj+yZMupwz0jdae
 NXvxvQzU8EjALz98FMJ824+bR/N8dQvIGEsNMfIsWj8pWBBGNn
 6C0j5JN/mTSdhbGXw5Xsg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen schrieb:
> However, in order to trigger the problem you also need to have NTP 
> servers that were erroneously broadcasting the addition of a leap second.

No matter what NTP servers send, it shouldn't result in a DoS.

> So most people didn't see the issue because there wasn't supposed to be 
> a leap second added this year...but they would have seen it the next 
> time a leap second was added.

True. It seems like we will have another one next year.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
