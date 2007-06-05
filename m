Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbXFEOqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbXFEOqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXFEOo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:44:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32217 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXFEOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=qKDJzOyZaBOZ3dMJ+kOaLm2pUotJXSuk3f5LbSb6bXJV8QXu+pj5mEivdseQCOy6r07c3/mxJfBd0aXodtCYcFaLwBxdhqbBgGP8wlQSgEEslFv4SKS8nnBUaoVCcTiNe6mXL7veo+46q3sQH81ns3KfNa5fbOsbh375U4Xbh0U=
Message-ID: <466576B9.2080203@googlemail.com>
Date: Tue, 05 Jun 2007 16:44:09 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Oliver Neukum <oneukum@suse.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Jiri Kosina <jikos@jikos.cz>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [5/5] 2.6.22-rc4: known regressions
References: <46657407.1000108@googlemail.com>
In-Reply-To: <46657407.1000108@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



USB

Subject    : Unable to get HID descriptor (error sending control message: Operation not permitted)
References : http://lkml.org/lkml/2007/6/2/153
Submitter  : Justin Piszcz <jpiszcz@lucidpixels.com>
Caused-By  : Kay Sievers <kay.sievers@vrfy.org>
             commit 9f8b17e643fe6aa505629658445849397bda4e4f
Handled-By : Oliver Neukum <oneukum@suse.de>
             Jiri Kosina <jikos@jikos.cz>
Status     : Unknown

Subject    : usb hotplug/udev cannot correctly register usb/scanners
References : http://lkml.org/lkml/2007/5/15/205
Submitter  : art@usfltd.com <art@usfltd.com>
Status     : Unknown



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
