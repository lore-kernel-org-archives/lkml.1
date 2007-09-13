Return-Path: <linux-kernel-owner+w=401wt.eu-S1763778AbXIMR0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763778AbXIMR0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXIMR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:26:45 -0400
Received: from tzmxr01.htp-tel.de ([81.14.243.17]:53927 "EHLO
	TZMXR01.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXIMR0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:26:44 -0400
Message-ID: <46E972C7.7080004@leemhuis.info>
Date: Thu, 13 Sep 2007 19:26:31 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070910)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Bernd Petrovitsch <bernd@firmix.at>,
       Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at> <pan.2007.09.12.17.30.59.597440@gmail.com> <1189620186.31502.96.camel@tara.firmix.at> <46E84208.1050903@leemhuis.info> <20070912200348.GA19434@uranus.ravnborg.org> <46E96EBE.8030108@leemhuis.info> <20070913172210.GA26864@uranus.ravnborg.org>
In-Reply-To: <20070913172210.GA26864@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.2007 19:22, Sam Ravnborg wrote:
> On Thu, Sep 13, 2007 at 07:09:18PM +0200, Thorsten Leemhuis wrote:
>> On 12.09.2007 22:03, Sam Ravnborg wrote:
>>>> I think the Fedora approach has many benefits -- I always wondered why
>>>> it never went upstream like a "make install_develstuff" that install all
>>>> the needed bits to
>>>>   /lib/modules/$(uname -r)/build/
>>> Last time I saw the patch is was to ugly to consider.
>> Do you have a pointer to that patch?
> See: http://lkml.org/lkml/2007/9/12/331
> Chris Wedgwood posted it today.

Missed that -- thx for the pointer and sorry for the noise.

Cu
knurd
