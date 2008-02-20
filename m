Return-Path: <linux-kernel-owner+w=401wt.eu-S1765031AbYBTNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765031AbYBTNBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764905AbYBTNAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:00:45 -0500
Received: from 87-194-173-43.bethere.co.uk ([87.194.173.43]:53680 "EHLO
	mail.goodmanemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764876AbYBTNAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:00:42 -0500
X-Greylist: delayed 1841 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 08:00:42 EST
Message-ID: <47BC1D44.3010808@goodmanemail.com>
Date: Wed, 20 Feb 2008 12:29:56 +0000
From: Alan Goodman <lists@goodmanemail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Chris Brennan <xaero@xaerolimit.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BT8x8 support
References: <47BB68ED.4070105@xaerolimit.net>
In-Reply-To: <47BB68ED.4070105@xaerolimit.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK to me!

Alan
> I have the following hardware installed in my Linux Box.
>
> 01:07.0 Multimedia video controller: Brooktree Corporation Bt878 Video
> Capture (rev 11)
> 01:07.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11)
>
> and the following devices installed in /dev
>
> 0 lrwxrwxrwx 1 root root       11 Feb 19 17:45 /dev/radio -> /dev/radio0
> 0 crw-rw-rw- 1 root video 81,  64 Feb 19 17:45 /dev/radio0
> 0 lrwxrwxrwx 1 root root        9 Feb 19 17:45 /dev/vbi -> /dev/vbi0
> 0 crw-rw-rw- 1 root video 81, 224 Feb 19 17:45 /dev/vbi0
> 0 lrwxrwxrwx 1 root root       11 Feb 19 17:45 /dev/video -> /dev/video0
> 0 lrwxrwxrwx 1 root root       10 Feb 19 11:59 /dev/video0 -> v4l/video0
> 0 lrwxrwxrwx 1 root root        9 Feb 19 17:45 /dev/vtx -> /dev/vtx0
> 0 crw-rw-rw- 1 root video 81, 192 Feb 19 17:45 /dev/vtx0
>
> As far as I can tell, I have bt8x8 support compiled as modules. here
> is a link to a copy of my .config. If someone can help me w/ making
> sure I have the right stuff in and what I don't need out as far as
> this card goes, I would be much appreciative.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

