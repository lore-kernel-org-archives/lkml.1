Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXIMRJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXIMRJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbXIMRJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:09:40 -0400
Received: from h3mxr02.htp-tel.de ([81.14.243.50]:21498 "EHLO
	H3MXR02.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXIMRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:09:39 -0400
Message-ID: <46E96EBE.8030108@leemhuis.info>
Date: Thu, 13 Sep 2007 19:09:18 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070910)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Bernd Petrovitsch <bernd@firmix.at>,
       Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at> <pan.2007.09.12.17.30.59.597440@gmail.com> <1189620186.31502.96.camel@tara.firmix.at> <46E84208.1050903@leemhuis.info> <20070912200348.GA19434@uranus.ravnborg.org>
In-Reply-To: <20070912200348.GA19434@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam!

On 12.09.2007 22:03, Sam Ravnborg wrote:
>> I think the Fedora approach has many benefits -- I always wondered why
>> it never went upstream like a "make install_develstuff" that install all
>> the needed bits to
>>   /lib/modules/$(uname -r)/build/
> Last time I saw the patch is was to ugly to consider.

Do you have a pointer to that patch?

Note that in Fedora it seems all (most of) the logic is afaics in the
rpm spec file itself and thus not suitable for the kernel  :-/

> Now that is maybe a year ago and I would be happy to take another look
> should someone submit it to me.

Maybe I should take a closer look at it sooner or later myself...

Cu
knurd
