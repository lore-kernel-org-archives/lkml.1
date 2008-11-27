Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYK0U7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYK0U7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYK0U7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:59:05 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:58950 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYK0U7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:59:04 -0500
Date: Thu, 27 Nov 2008 21:59:00 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
In-Reply-To: <20080828200120.GA16462@cs181140183.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-08-28 22:01, Adrian Bunk wrote:
>On Thu, Aug 28, 2008 at 09:05:53PM +0200, Tejun Heo wrote:
>> Hello again,
>> 
>> So, after all the fuss, here's the state-of-the-art standard-compliant
>> cloud-computing web-3.0-beta web page for OSS emulation using CUSE.
>> 
>>   http://userweb.kernel.org/~tj/ossp/
>> 
>> It works pretty well here.  :-)
>
>Sorry for being destructive, but 6 years after ALSA went into the
>kernel we are slightly approaching the point where all applications 
>support ALSA.

Unreal Tournament GOTY/99 does not (seem to). And I doubt someone
is going to fix commercial games. Though being a static binary,
its use of shared libraries that do the sound device open makes
aoss a possibility, if that helps. But it does not support ALSA
natively - and would make a point for CUSE.
