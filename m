Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbXJLWiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbXJLWiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbXJLWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:17 -0400
Received: from mylar.outflux.net ([69.93.193.226]:40762 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbXJLWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:15 -0400
X-Greylist: delayed 2261 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 18:20:15 EDT
Date: Fri, 12 Oct 2007 15:20:08 -0700
From: Kees Cook <kees@ubuntu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: static LSM objection
Message-ID: <20071012222008.GA10703@outflux.net>
References: <20071012214227.GY10703@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012214227.GY10703@outflux.net>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 02:42:27PM -0700, Kees Cook wrote:
> I just wanted to voice my opinion about the static LSM changes.

Through the magic of greylisting (thanks vger) and IRC, I've just had a
chat with Arjan and GregKH about this stuff.  So, just to follow up for
people interested in watching me talk to myself:

- while an LSM must be compiled in, they are not mutually exclusive,
  and the desired module can be selected at boot-time.

As such, I don't have any strong objections.  It'd be nice for folks
doing LSM development to allow for a way for it to be modular, but I'll let
them fight for that.  :)

Sorry for the noise,

-Kees

-- 
Kees Cook
