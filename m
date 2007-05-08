Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXEHU1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXEHU1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXEHU1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:27:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41530
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbXEHU1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:27:37 -0400
Date: Tue, 08 May 2007 13:27:37 -0700 (PDT)
Message-Id: <20070508.132737.104034594.davem@davemloft.net>
To: penberg@cs.helsinki.fi
Cc: jeff@garzik.org, linville@tuxdriver.com, dcbw@redhat.com,
       hch@infradead.org, linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
References: <20070507141143.GB5125@tuxdriver.com>
	<463F443A.5000306@garzik.org>
	<84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Date: Tue, 8 May 2007 12:47:34 +0300

> On 5/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> > Open source is about release early, release often.  Not "hide code in a
> > dark corner until Christoph thinks it is perfect."  We have high
> > standards for upstream merged code, but that standard is not perfection.
> 
> Please. This has nothing to do with Christoph. (1) the driver seems to
> break every Linux coding style convention known to man and (2) adds a
> new ABI with bunch of ioctls() that apparently haven't been reviewed
> properly. That's just not acceptable for mainline kernel!

I completely agree, these things should be corrected and if the the
author is being totally unresponsive to Christoph's review that's even
worse.

Every piece of code that I've written that Christoph has reviewed has
become significantly better because of his review.
