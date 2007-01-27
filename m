Return-Path: <linux-kernel-owner+w=401wt.eu-S1750958AbXA0JUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbXA0JUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXA0JUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:20:32 -0500
Received: from guri.is.scarlet.be ([193.74.71.22]:38327 "EHLO
	guri.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbXA0JUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:20:31 -0500
Message-ID: <45BB18DE.1090802@joow.be>
Date: Sat, 27 Jan 2007 10:18:22 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux1394-Devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc6-rt2: kernel oops when ejecting cardbus firewire card
References: <45BA743B.2080401@joow.be> <45BA85A1.1030707@s5r6.in-berlin.de>	<45BB106E.706@joow.be> <45BB14A7.6040400@s5r6.in-berlin.de>
In-Reply-To: <45BB14A7.6040400@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: guri 20001; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Pieter Palmers wrote:
>> Stefan Richter wrote:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=7121
>> Oops, missed that. Sorry for the noise.
> 
> No, it's OK. We have a pile of old open bugs, and those that are rubbed
> in our face more often might even get a chance to be fixed some day... :-/

OTOH, dv1394 is scheduled for removal. Not that we should tolerate bugs 
in the Linux kernel ;), but it lowers priority I guess.

For me the solution is simple: I don't need dv1394, so I just don't 
build it anymore. It has the annoying tendency to auto-load when raw1394 
is loaded.

Pieter
