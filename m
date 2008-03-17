Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYCQWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYCQWES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYCQWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:04:06 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60968 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYCQWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:04:05 -0400
Message-ID: <47DEEB07.7010504@keyaccess.nl>
Date: Mon, 17 Mar 2008 23:04:55 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: twhitehe@uwo.ca
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080314131344.62A59DBA2@gherkin.frus.com> <200803142118.31974.twhitehe@uwo.ca>
In-Reply-To: <200803142118.31974.twhitehe@uwo.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-03-08 02:18, Tyson Whitehead wrote:

> With regard to the sound driver, the es18xx does endless looping on the first 
> second or so of sound on my box (a PWS500au) unless I apply my patch, which 
> just enables the alternative interupt detection code in the driver.  Even 
> then, though, I believe it still only works in 8bit mode.

Could you attach that patch? Links I'm finding are to

http://whitehead.apmaths.uwo.ca/~tyson/

which seems to be dead.

> The sb8 driver also works for me.  For this reason, I basically decided to 
> forget about my es18xx patch.  It doesn't get me anything the sb8 driver 
> doesn't give me, and it forces me to keep compiling my own kernels.
> 
> Cheers!  -Tyson
> 
> PS:  The Debian 2.6.24 kernel actually panicked on me (instead of infinitely 
> looping on the first second of sound) when I tried the stock es18xx driver.

Rene.
