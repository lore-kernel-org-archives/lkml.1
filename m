Return-Path: <linux-kernel-owner+w=401wt.eu-S933994AbYDVOBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbYDVOBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762105AbYDVOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:01:25 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:17835 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbYDVOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d+HMA+MxavBifnGPeM/nOjzqd1VL7XQLFrR+VrULJE/nTiCAExlmNQnAdVScIOq4AByLFWOMGl/1N7nr7/9NdvO3qJIlgSpMQ9yRGxQ8LOR9jhH7DfZsVBM7VL8c51v0bkZGLdYvyWFkAQJQcdBbzLJvJzc/JHskc1d2YY5KMMo=
Date: Tue, 22 Apr 2008 10:01:16 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stas Sergeev <stsp@aknet.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
Message-ID: <20080422084401.ZZRA012@mailhub.coreip.homeip.net>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <20080419021343.GA3503@nineveh.local> <20080418200237.b5a9e805.akpm@linux-foundation.org> <20080419041429.GA8508@anvil.corenet.prv> <20080418212934.bbe84ee2.akpm@linux-foundation.org> <s5h8wz7cng7.wl%tiwai@suse.de> <480CD50F.20706@aknet.ru> <s5hbq42b3j7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbq42b3j7.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takashi, Stas,

On Tue, Apr 22, 2008 at 12:13:48PM +0200, Takashi Iwai wrote:
> 
> It's no big problem but I just find the phrase "you have to
> disable..." too strict.  It's just a sound-quality problem as you
> mentioned in the above.
> 

Just out of curiosity, what is the sound quality with the PC speaker?
Not to belittle Stas's effort, but how relevant is this driver for
mainline given that it os pretty much impossible nowadays to find a
motherboard without on-board sound?

-- 
Dmitry
