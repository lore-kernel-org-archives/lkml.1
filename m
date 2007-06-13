Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXFMIrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXFMIrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXFMIrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:47:02 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20417 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbXFMIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Qu/ypxoO8SEokc6lvOhPuqXmCZjPEhQ1GkIGeFM3UMLRcGF/d7ANTzIJ/V8xpBKbCOW8Cn4qzURpvCexRwafcpuoyaPjA4MSguB44iyN8Qrx0ylcc3i/TpKjfrTqR90FUnKsLEhczfFNleLj/+JTqf4zsXaYM+dFYdoFCiLG1nw=
Message-ID: <466FAF01.20009@gmail.com>
Date: Wed, 13 Jun 2007 10:46:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mdharm-usb@one-eyed-alien.net,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb() [Was:
 2.6.22-rc4-mm2]
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <466FABDD.1050807@gmail.com>
In-Reply-To: <466FABDD.1050807@gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Andrew Morton napsal(a):
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/

> after plugging my camera in, I get this:
[...]
> USB Mass Storage support registered.
> WARNING: at /home/l/latest/xxx/drivers/usb/core/urb.c:293 usb_submit_urb()
[...]
> Are you aware of such problems? Any other info needed?

Aha, you are, going to try http://lkml.org/lkml/2007/6/7/197

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
