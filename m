Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbXEME42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbXEME42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 00:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXEME4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 00:56:20 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1241 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXEME4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 00:56:19 -0400
From: James Cloos <cloos@jhcloos.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: discuss@x86-64.org, Simon Arlott <simon@fire.lp0.eu>, trivial@kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [discuss] [PATCH] spelling fixes: arch/x86_64/
In-Reply-To: <200705121825.26430.ak@suse.de> (Andi Kleen's message of "Sat\, 12
	May 2007 18\:25\:26 +0200")
References: <4644C783.3090805@simon.arlott.org.uk>
	<200705121825.26430.ak@suse.de>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.0 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAMnRFWHRUaXRsZQAvbWF4dG9y
 L2Nsb29zL2luY29taW5nLzIwMDQvMDIvUFdHL0pIQzE2LnBuZyJMlEwAAAAadEVYdFNvZnR3YXJl
 AEdOT01FIEljb24gRWRpdG9ynioKbAAAAHFJREFUeJzFk8EKwCAMQ1/ED9cvzw6iuM0N9WIvDTWE
 1KjAxmKnLBEBjLcEIBCeI2nccy5YKrjxwbbvAvZ37zlo4GB9iRMC/cq/AppItwmMyJ5I98wd9G7P
 xxgrSKlYS2lMrOcV13o95aVSKA7E5ndGXG+IIzcl4BNfAAAAAElFTkSuQmCC
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
X-Hashcash: 1:23:070513:linux-kernel@vger.kernel.org::sXNqN2OsnAKe6r1c:0000000000000000000000000000000009RLk
X-Hashcash: 1:23:070513:ak@suse.de::52AAH+Iz4d3+mpZN:0000000DoEb
X-Hashcash: 1:23:070513:discuss@x86-64.org::f+ZMDfpxZX77PTxo:0000000000000000000000000000000000000000000BmKZ
X-Hashcash: 1:23:070513:trivial@kernel.org::x6FZ6QX1wr+d+jJu:0000000000000000000000000000000000000000000Ac1S
X-Hashcash: 1:23:070513:simon@fire.lp0.eu::vjeQXq5mYjX0TZ1m:00000000000000000000000000000000000000000000I3mF
Date: Sat, 12 May 2007 21:27:59 -0400
Message-ID: <m3abw9a4w9.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andi" == Andi Kleen <ak@suse.de> writes:

>> -		/* Reenable any watchpoints before delivering the
>> +		/* Re-enable any watchpoints before delivering the

Andi> reenable gets >140k google hits so it seems to be an really
Andi> used word.

Essentially all commonly used English words which start out with hyphens
loose them over time.  It starts out with typos and progresses until the
non-hyphenated form becomes the exclusively used form.  It does seem that
re-enable → reenable is occurring, based on those search hits.

Andi> Similar with upto.

I’ve a *much* harder time agreeing with «upto» in place of «up to».
That should be treated as a typo in need of fixing.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
