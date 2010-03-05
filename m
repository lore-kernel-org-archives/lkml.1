Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0CEFRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:17:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab0CEFRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:17:45 -0500
Date: Thu, 4 Mar 2010 21:17:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <21d7e9971003041728u7f7477f4g16805bc1ee235e8f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003042114340.3768@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon>  <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>  <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>  <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> 
 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>  <1267748927.3496.6.camel@nisroch>  <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>  <20100305005617.GA31883@skynet.be>  <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain> 
 <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain> <21d7e9971003041728u7f7477f4g16805bc1ee235e8f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Dave Airlie wrote:
> 
> wget http://kojipkgs.fedoraproject.org/packages/xorg-x11-drv-nouveau/0.0.16/2.20100218git2964702.fc13/src/xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.src.rpm
> rebuild + install.

This one doesn't work on F12.

It wants xorg-x11-server-devel > 1.7.99.3-3.

Is there some limited set of rpm's I can get from the f13 archive? 

		Linus


