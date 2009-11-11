Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZKKVsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZKKVsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbZKKVsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:48:02 -0500
Received: from winfree.gag.com ([192.133.104.8]:49776 "EHLO winfree.gag.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759416AbZKKVsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:48:01 -0500
Subject: Re: problem with codec discovery on HP 2530p
From: Bdale Garbee <bdale@gag.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <s5hy6md600u.wl%tiwai@suse.de>
References: <20091110145338.A55E719D7AD@rover.gag.com>
	 <s5hy6mel48j.wl%tiwai@suse.de> <1257886598.4701.3.camel@rover>
	 <s5hy6md600u.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 16:48:03 -0500
Message-ID: <1257976083.5237.1.camel@rover>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 07:36 +0100, Takashi Iwai wrote:

> But, single_cmd=1 is obviously not good.  This options is just for
> debugging purpose.  That's why that commit hits.

Ok, thanks, that fixed it.  

I wasn't aware that I'd done something to set that option, but indeed I
had.  Perhaps it fixed a problem in some earlier kernel revision... I
really do not recall!

Bdale



