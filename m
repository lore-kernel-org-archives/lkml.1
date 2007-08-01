Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXHAJix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXHAJix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761288AbXHAJie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:38:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:52214 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257AbXHAJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=E4fi2JvV9vMsafe7qtCmWoiJEFX8QzVwxQEYpQdcA93cR+tfEwWfMKcZu7itTCSxRnT/Enffffo3PdtuFOMcNL6Y5yS8H/2Ge2yRsT0a9Cd6SSCMWZgbFkshZIACjZT/FPxx8vHLLpXLcuMR2vGvAkCJcvtC6XRIoII/RYAKdyk=
Message-ID: <46B05484.8080701@googlemail.com>
Date: Wed, 01 Aug 2007 11:38:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, linuxppc-embedded@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Typo fixes interrrupt -> interrupt
References: <46AFFB0B.102@googlemail.com> <20070801144318.f81fd988.sfr@canb.auug.org.au>
In-Reply-To: <20070801144318.f81fd988.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Wed, 01 Aug 2007 05:16:27 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
>>  arch/powerpc/platforms/iseries/it_lp_naca.h       |   87 +++++++++++----------
> 
> NAK this part as it just makes a lot of the lines more than 80 characters
> for no real gain on a platform that is moving on ...

Well some were there before but with the wrong comment style.

I'll send an new patch in a bit without the comments fixes.


Gabriel
