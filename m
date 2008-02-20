Return-Path: <linux-kernel-owner+w=401wt.eu-S1764184AbYBTXq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764184AbYBTXq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbYBTXqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:46:50 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30256 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYBTXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:46:49 -0500
Date: Wed, 20 Feb 2008 17:46:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: BT8x8 TV Card
In-reply-to: <fa.8THcxUS0tA6NGzMwMdJ0gEixmMw@ifi.uio.no>
To: Chris Brennan <xaero@xaerolimit.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <47BCBBCA.1080307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8THcxUS0tA6NGzMwMdJ0gEixmMw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Brennan wrote:
> I'm having a kernel related issue (I think) with the BT878 card I have
> in my gentoo box.
> 
> Here are pastebin results of varius infomation, I hope I give all the
> necessary info. If I am missing something or you need more, please let
> me know.
> 
> dmesg -> http://rafb.net/p/MVIiSg62.html
> xorg.conf -> http://rafb.net/p/dXz4Ry49.html
> Xorg.0.log -> http://rafb.net/p/LbPBZT56.html
> config -> http://rafb.net/p/Dm5LDM88.html

These links don't work.

> 
> xawtv gives me a window and when I right click, I can choose what
> format and region and all that jazz, but I get no picture. I do get a
> green overlay w/ some static when it doesn't cause my X Session to
> freeze. Below is the console output of two apps I am trying to use to
> access the TV Card.
> 
> tvtime produces the following error:
> 
>     xaero@Leviathan ~ $ tvtime
>     Running tvtime 1.0.2.
>     Reading configuration from /etc/tvtime/tvtime.xml
>     Reading configuration from /home/xaero/.tvtime/tvtime.xml
>     xvoutput: No XVIDEO port found which supports YUY2 images.
> 
>     *** tvtime requires hardware YUY2 overlay support from your video card
>     *** driver.  If you are using an older NVIDIA card (TNT2), then
>     *** this capability is only available with their binary drivers.
>     *** For some ATI cards, this feature may be found in the experimental
>     *** GATOS drivers: http://gatos.souceforge.net/
>     *** If unsure, please check with your distribution to see if your
>     *** X driver supports hardware overlay surfaces.
> 
>     xaero@Leviathan ~ $
> 
> tvtime-scanner now that made my heart jump ... cause it scanned and
> stored all my basic cable channels. But I still can't get a video
> signal. So I am obviously missing something.
> 
> 
> So hopefully someone can help me

I assume you did read the message tvtime spit out and looked into it?
