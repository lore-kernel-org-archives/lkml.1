Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYBRRIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYBRRIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYBRRHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:07:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44323 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYBRRHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:07:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
Date: Mon, 18 Feb 2008 18:06:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Kosina <jkosina@suse.cz>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com> <200802181741.09046.rjw@sisk.pl> <47B9BA73.7020909@balabit.hu>
In-Reply-To: <47B9BA73.7020909@balabit.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181806.32741.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
> Hello,
> 
> Rafael J. Wysocki wrote:
> > On Monday, 18 of February 2008, Laszlo Attila Toth wrote:
> >
> > 
> > All in all, I gather you wanted me to test the patch below. :-)
> > 
> > Yes, that helps.
> 
> Thanks for the testing. Dave already reverted the patch, also I don't 
> know I should resend it or leave it as is.

Since the patch has been reverted, I think you can fold the fix into it
and send it again for the next merge window (unless it's _really_ urgent).
Of course, if that's fine by Dave. :-)

Thanks,
Rafael
