Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXECXGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXECXGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXECXGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:06:33 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:3881 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754463AbXECXGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:06:32 -0400
Date: Fri, 4 May 2007 09:08:24 +1000
From: CaT <cat@zip.com.au>
To: Greg KH <gregkh@suse.de>
Cc: Anton Vorontsov <cbou@mail.ru>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070503230824.GE2174@zip.com.au>
References: <20070503213139.GC20067@zarina> <20070503225346.GA12892@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503225346.GA12892@suse.de>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:53:46PM -0700, Greg KH wrote:
> >     	# cat /sys/class/power\ supply/
> >     	ac/           main-battery/ usb/
> 
> Um, shouldn't that be an error?  Isn't /sys/class/power\ supply/ a
> directory?

I think that's more of a case of:

cat /sys/class/power\ supply/<tab><tab>

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
