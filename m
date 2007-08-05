Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXHEChS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXHEChS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 22:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763031AbXHEChH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 22:37:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:50918 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbXHEChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 22:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uv+NnDMeQoK0GpxSGZbFWIKU/Z6EBfkzSbZf+hmjRheQw3ARULydaR+StpxKcutQCH3nftt3m7bDoxlwGx3xmBiT5vUNsAIUveX9vMA7ieAyrItwBkTRYXp8S/CRAj2V3iX97HUHUFrCGrtB30ZI4/v9yxcIiwM03ybEIpapHSE=
Message-ID: <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com>
Date: Sun, 5 Aug 2007 10:37:03 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.23-rc2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <46B4C011.8090802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
	 <46B4C011.8090802@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, H. Peter Anvin <hpa@zytor.com> wrote:

> Also, can you please describe "messed up" in more detail?

The screen went into some graphic mode that can't be reset no matter
what I tried (stty reset). I see all kinds of ramdom pattern/color
everywhere. Then typing "startx" would get in X just fine. But trying
to get back to console (ALT F1) or (Ctrl ALT BackSpace) would still
end up with the messed-up console.

> We had one report of "screen messed up" already that did get fixed
> (CONFIG_FIRMWARE_EDID not working.)

How can I try this?

> Are you using the VGA console or a framebuffer console?

VGA console.

> Also, please submit your .config and kernel command line.

I'll get this to you later today. Don't have my PC with me now.

Thanks,
Jeff.
