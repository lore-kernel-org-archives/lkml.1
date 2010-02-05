Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab0BEHLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:11:14 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34553 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0BEHLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ou77lvxvSSd7bPFHQjvNDIZ3Bg0aEfz8fWA/sQRpjf1UF99rxPks9/hCzjSHxDVGCC
         T8SGZbAt1VBm1O/0O1Y7rIb8QiWA83pZ6OKJYnUPJF35Jw7inaybhsUb57Bx8HAmfbHr
         pZD7cBKQSbmWD34aEQ6QD+5Ox8olapyqM9xu4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002050411100.22568@skynet.skynet.ie>
References: <alpine.DEB.2.00.1002050411100.22568@skynet.skynet.ie>
Date: Fri, 5 Feb 2010 08:11:11 +0100
Message-ID: <b170af451002042311h444e8074g7678b6ffd3ddf3fe@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/5 Dave Airlie <airlied@linux.ie>:
>
> Hi Linus,
>
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>
> All radeon related: 2 warning fixes
> 2 r600/700 regression fixes
> 1 r100/r200 rendering fix (always broken with KMS)
> 1 HDMI audio regression work around - turn off audioon that hw for now
> 1 oops fix seen on Ingo's machine in the failure path
> 2 rs480 fixes from my laptop - one fixes scary MC idling messages
> 1 r300 vram width calc fix.

Dave, one again you forgot my audio suspend&resume patch that kills
many error messages showing on resume and fixes audio as well.

-- 
Rafał
