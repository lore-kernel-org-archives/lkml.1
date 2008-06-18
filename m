Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYFRHYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYFRHYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYFRHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:24:33 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:59999 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYFRHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:24:32 -0400
Message-ID: <4858B84B.4030800@keyaccess.nl>
Date: Wed, 18 Jun 2008 09:24:59 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: mulix@mulix.org, linux-kernel@vger.kernel.org,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: looping S/PDIF data
References: <20080531112606.5884a1c9@mjolnir.drzeus.cx> <20080617215504.3203a5ed@mjolnir.drzeus.cx>
In-Reply-To: <20080617215504.3203a5ed@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-06-08 21:55, Pierre Ossman wrote:

> Ping
> 
> On Sat, 31 May 2008 11:26:06 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
>> I have a minor annoyance with the snd_trident driver that I was hoping
>> you might have a fix for:
>>
>> Pausing the output does not seem to take on the S/PDIF output. Analog
>> outputs properly stop in their tracks, but the S/PDIF port keeps
>> looping the current data buffer, which gives a rather unpleasant end
>> result. :)

Try the alsa-devel list...

Rene.
