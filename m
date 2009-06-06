Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZFFWWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZFFWWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZFFWW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:22:29 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50039 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZFFWW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ca9qX5XPKVCW7P5BzZ3l6kA0tTmr3VLR6SN0omMn63UkxDX4OS9Mqo43vFLKGlVer0
         M7dHDMN4JGnN7YT4k4+NO528jvm3Aw3V5U2PQlfs8giQD20QgQ5ZYl3LqS3sUwTMVBG1
         7F7EbWeRAhPR8x5qFaBIaGIFBEXMM36ibz5SA=
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 01:22:23 +0300
Message-Id: <1244326943.12159.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 12:04 -0700, Luis R. Rodriguez wrote:
> I'm pleased to announce we have released the source code to our
> Atheros 802.11n USB Otus/ar9170 device under the GPL. You can grab the
> source, compile and use it with the upstream ar9170 device driver.
> Patches are welcomed. The git tree available for this is at:
> 
> http://git.sipsolutions.net/ar9170-fw.git
> 
> For more information please visit the home page for this project is on
> our Linux wireless wiki:
> 
> http://wireless.kernel.org/en/users/Drivers/ar9170.fw
> 
> The ar9170 device driver home page is at:
> 
> http://wireless.kernel.org/en/users/Drivers/ar9170
> 
> I'd like to thank Johannes Berg and Christian Lamparter for their
> incredible contributions to the project both firmware and ar9170
> driver so far without which this would not have been possible.

I just want to say thanks!

I will buy this device very soon.
Is this source for same firmware that was closed?
Will AP mode work in future?

If you were to release the documentation, then it would be really
possible to fix AP mode for this firmware.


If you could just release ath5k documentation.... I would fix its
numerous problems I have with my aspire one (AR2425)...


Best regards,
	Maxim Levitsky

