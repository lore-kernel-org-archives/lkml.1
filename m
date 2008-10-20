Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYJTJut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYJTJut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYJTJul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:50:41 -0400
Received: from mail.anarazel.de ([217.115.131.40]:53659 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYJTJul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:50:41 -0400
From: Andres Freund <andres@anarazel.de>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [git pull] agp patches for 2.6.28-rc1.
Date: Mon, 20 Oct 2008 11:50:37 +0200
User-Agent: KMail/1.10.1 (Linux/2.6.27-andres-05577-g0cfd810; KDE/4.1.2; x86_64; ; )
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0810160758320.16504@skynet.skynet.ie> <200810200358.52147.andres@anarazel.de> <1224469147.5303.47.camel@koto.keithp.com>
In-Reply-To: <1224469147.5303.47.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201150.37605.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Monday 20 October 2008 04:19:07 Keith Packard wrote:
> If you care to try the above fix against your current driver sources,
> that would be helpful for us.
Ok, tested with 2.4.1 and  current linus git 
(0cfd81031a26717fe14380d18275f8e217571615) and it works without problems so 
far.

I have a good reason to say no to bisection requests now ;-) switching drivers 
every bisection run is annoying (unfortunately I could just cherry-pick the fix 
and rebase, but who knows that...)

Andres

