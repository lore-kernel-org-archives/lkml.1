Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbXBVXcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbXBVXcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXBVXcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:32:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:62954 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbXBVXcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hudeRklxzyyXTb60GuFGZ6fnl4am1aekP8Mm0B14M144G0SvUZkzvk7e21PUJVFolbKcnz6wBh/9PnK+oMjajyUNGv9xoqmOgAiMBBwf465/yfMRUXWhENIiV4WvQoy8dnyHt+LhDwpIiUbOVFNv/jAnaFvFgZRiiHXGfCfOhhA=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Luca Tettamanti <kronos@people.it>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       James Simmons <jsimmons@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070222203904.GA15349@dreamland.darkstar.lan>
References: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
	 <20070128162907.370f5476.akpm@osdl.org>
	 <21d7e9970701281639w57edc2efw4ba620d4c1bdcee7@mail.gmail.com>
	 <cb7bb73a0701290637q2ce0ff16t28f82d0c0339a2ba@mail.gmail.com>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <20070222203904.GA15349@dreamland.darkstar.lan>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 07:34:11 +0800
Message-Id: <1172187251.4279.9.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 21:39 +0100, Luca Tettamanti wrote:
> Il Thu, Feb 22, 2007 at 09:01:52AM +0100, Giuseppe Bilotta ha scritto: 
> > On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > >On Wed, 2007-02-07 at 00:08 +0100, Giuseppe Bilotta wrote:

> 
> Still scratching my head :|
> 
> Tony,
> this is the patch (modulo cosmetic stuff) that I sent to Giuseppe. I
> believe it's correct (I cross checked with X.org driver):
> 

Yes, the patch does look correct.  I also don't understand why
Giuseppe's hardware failed to do i2c with this...

Tony


