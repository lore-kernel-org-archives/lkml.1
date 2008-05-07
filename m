Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbYEGS2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbYEGS2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYEGS2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:28:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYEGS23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=khmR2dbg5X97fXRtRTqZ9CWVeCQhLiPhUuvqUATmLI+mBSKQzK3HVEUg0X/XVEcos6//3DFPGyKcra+X87rSCwq3N0PfABw70SPRIhTLi0ceKf1LCSwfgBG0Ro3knYtEme5wc1UGTO1SWno7G8KpD/067YaXvsFuZh6+MamWvZQ=
Message-ID: <c878e2290805071128s34603039y3463d0c99253bfcf@mail.gmail.com>
Date: Wed, 7 May 2008 20:28:27 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
Cc: linux-kernel@vger.kernel.org, drzeus@drzeus.cx
In-Reply-To: <c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
	 <202777.76958.qm@web36706.mail.mud.yahoo.com>
	 <c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 6:50 PM, Kim Hansen <kimhanse@gmail.com> wrote:
>
> I have captured some logs now, there is logs of a successful insert
> and remove, and of an unsuccessful.
>
> Successful  insert: 16:18:50   remove:  16:20:26
> Unsuccessful insert:  16:21:38  remove:  16:21:47
>
> The log can be found at: http://i9.dk/~kim/mmc-log.txt.bz2

I just tested on 2.6.25, and the behaviour is the same as on 2.6.24.
Sometimes the SD-card is accepted, other times is it rejected with the
'low voltage range' error, the logging is also the same.

-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
