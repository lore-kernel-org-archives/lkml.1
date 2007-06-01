Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbXFAO3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbXFAO3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 10:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXFAO26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 10:28:58 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:3102 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758096AbXFAO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 10:28:57 -0400
Date: Sat, 2 Jun 2007 00:30:55 +1000
From: CaT <cat@zip.com.au>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070601143055.GD3807@zip.com.au>
References: <20070601142058.GA2587@DervishD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601142058.GA2587@DervishD>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 04:20:58PM +0200, DervishD wrote:
>     This said, I know that the console will give me no problems
> regarding character representantion (heck, I'm pretty sure that I will
> be able to use even the same font I'm using right now in the console if
> I get the proper unicode map), but probably will give me problems when
> *entering* characters. I've read that the kernel handles accented chars,
> and things like '?' (ntilde) because it assumes that any composed
> character (composed using dead keys, for example) is in the latin1
> range. While this is not a perfect behaviour, it will work for me.

Hmmm. I've not yet played with moving to utf-8 but would

man console_codes

be of help to you?


-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
