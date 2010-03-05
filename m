Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0CEMgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:36:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35418 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750811Ab0CEMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:36:48 -0500
Date: Fri, 5 Mar 2010 12:38:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
In-Reply-To: <20100305064955.GA6453@elte.hu>
References: <20100304103655.0b14343f@jbarnes-piketon>
	<20100304103929.6eb81d45@jbarnes-piketon>
	<alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	<20100304105624.70fe845e@jbarnes-piketon>
	<alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
	<21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
	<alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
	<21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	<alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	<1267748927.3496.6.camel@nisroch>
	<20100305064955.GA6453@elte.hu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The conclusion is crystal clear, breaking an ABI via a "flag day" 
> cleanup/feature/etc is:

Ingo go read the staging Kconfig. It's crystal clear, and lots of vendor
junk that is in there being cleaned up it would be *insane* to keep their
old APIs

See there's a bigger offence than breaking an ABI - its called not RTFM.

Alan
