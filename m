Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXFYJsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXFYJsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXFYJsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:48:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53540 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbXFYJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=qDulcn8Dy8UPCPC9Rpfz/dlLC8S34e7JWRqV8fbjZ4D1GinvbfqPGpBbaiGPle8Ek0FiuKRu2IotomI0+iqY1IR8cRB2ydvNPmrkm9kHEzgeWSqnXHg93Ol/61bdu5HEOkOykgmguXHnnIC4xyKFvK91HVhiHjumcOP5w/ufiuk=
Message-ID: <467F8F63.2070101@googlemail.com>
Date: Mon, 25 Jun 2007 11:48:19 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       =?ISO-8859-2?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Samuel Ortiz <samuel@sortiz.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [2/2] 2.6.22-rc6: known regressions with patches
References: <467F894C.4000604@googlemail.com>
In-Reply-To: <467F894C.4000604@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

*STATISTICS* (a.k.a. list of aces)

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             1
Hugh Dickins                           1
Jean Delvare                           1



FBDEV

Subject    : mach64 breakage in 2.6.22
References : http://lkml.org/lkml/2007/6/14/73
Submitter  : Olaf Hering <olaf@aepfle.de>
Handled-By : Ville Syrjälä <syrjala@sci.fi>
Patch      : http://lkml.org/lkml/2007/6/21/216
Status     : patch was suggested



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



Networking

Subject    : ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
References : http://lkml.org/lkml/2007/6/19/310
Submitter  : Olaf Hering <olaf@aepfle.de>
Patch      : http://lkml.org/lkml/2007/6/19/382
Status     : patch was suggested

Subject    : no irda0 interface (2.6.21 was OK), smsc does not find chip
References : http://lkml.org/lkml/2007/6/3/16
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Handled-By : Samuel Ortiz <samuel@sortiz.org>
             Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch      : http://lkml.org/lkml/2007/6/7/237
Status     : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
