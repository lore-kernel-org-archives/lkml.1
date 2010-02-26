Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607Ab0BZIxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:53:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47639 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935550Ab0BZIxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ICIhpOC5fI5ukovaUPRHWvclCIgbb+UNlkwkciejyF/G/EIgpoBZOAfN+rhMSePU0v
         RB5q4/LyvM8nGjktzBt4ixjLgIXG7SHJwcGJwMnjI1iNA8N2+QkTvFU8B35WgxN110qK
         P6JimnQpu5yvm0Pbnfu3e94yQteKVav579jI8=
MIME-Version: 1.0
In-Reply-To: <21d7e9971002260050h37eff655k3b667528b9cca333@mail.gmail.com>
References: <1267074476-28347-1-git-send-email-airlied@gmail.com>
	 <1267074476-28347-2-git-send-email-airlied@gmail.com>
	 <1267074476-28347-3-git-send-email-airlied@gmail.com>
	 <b170af451002250119y52c7097er995e7592248128c0@mail.gmail.com>
	 <21d7e9971002260050h37eff655k3b667528b9cca333@mail.gmail.com>
Date: Fri, 26 Feb 2010 09:53:07 +0100
Message-ID: <b170af451002260053g4c632e3fya772c9d9ca62ec6b@mail.gmail.com>
Subject: Re: [PATCH 2/2] vga_switcheroo: initial implementation (v8)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 lutego 2010 09:50 użytkownik Dave Airlie <airlied@gmail.com> napisał:
> Oh I should probably have dropped all the audio bits, I didn't even
> see this reply
> before I updated to v11.
>
> The r600 audio code is a bit of disaster area hopefully we can clean it up, like
> the timer was firing after the device was suspended.
>
> I'll repost with all that r600 audio ripped out and you can fix the mess.

I already did, 3 minutes ago ;)

-- 
Rafał
