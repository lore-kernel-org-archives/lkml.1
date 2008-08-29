Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYH2IKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYH2IKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYH2IJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:09:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58981 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYH2IJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:09:53 -0400
To: tj@kernel.org
CC: bunk@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
       miklos@szeredi.hu, tiwai@suse.de, fuse-devel@lists.sourceforge.net
In-reply-to: <48B7A48B.8020405@kernel.org> (message from Tejun Heo on Fri, 29
	Aug 2008 09:26:03 +0200)
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <48B751DA.5090906@kernel.org> <20080829065026.GC16462@cs181140183.pp.htv.fi> <48B7A48B.8020405@kernel.org>
Message-Id: <E1KYz3H-0005Wn-4X@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Aug 2008 10:09:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Tejun Heo wrote:
> Most major ones do, but there are programs and games which just haven't
> fared off as well as more popular ones and thus just stopped being
> updated and then there are commercial games which won't be updated in
> any foreseeable future.  There are reasons why something as brand new as
> pulse comes with something like padsp.

I have to agree with Tejun, there will always be old executables lying
around and source code that nobody will bother updating that still use
legacy interfaces.

I have a handful of programs that are still OSS only (one of them,
spectemu, being still popular enough to be in several major distros).

I could update them to alsa, but most of them I use once or twice a
year, it doesn't make sense.

In all the world there are probably thousands of such apps, and
porting each and every one to newer interfaces (if it could be done at
all) would probably be a much bigger effort then implementing a
backward compatibility layer for OSS.

Miklos
