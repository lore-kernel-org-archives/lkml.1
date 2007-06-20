Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbXFTSwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbXFTSwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764372AbXFTSv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:51:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764543AbXFTSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:51:56 -0400
Message-ID: <46797747.9020904@zytor.com>
Date: Wed, 20 Jun 2007 11:51:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>	 <20070619150824.GH11781@holomorphy.com>	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>	 <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com> <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>
In-Reply-To: <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan wrote:
> Putting this into the security policy was an error born of
> lazyness to begin with. Abuse of the security mechanism
> was easier than hacking the toolchain, ELF loader, etc.
> 
> Either a binary needs self-modification, or it doesn't. This is
> determined by the author of the code. If you don't trust an
> executable that needs this ability, then you simply can not
> run it in a useful way.

That's fine.  That's a policy decision.  That's what a security policy
*is*.  The owner of the system has decided, by security policy, that
that is not allowed.  Bypassing that is not acceptable.

	-hpa
