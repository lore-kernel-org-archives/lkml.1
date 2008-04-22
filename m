Return-Path: <linux-kernel-owner+w=401wt.eu-S1764828AbYDVNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764828AbYDVNid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYDVNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:38:24 -0400
Received: from www.tglx.de ([62.245.132.106]:38994 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505AbYDVNiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:38:23 -0400
Date: Tue, 22 Apr 2008 15:35:55 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Ben Nizette <bn@niasdigital.com>
Cc: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] UIO: generic platform driver
Message-ID: <20080422133549.GA2279@local>
References: <20080422094708.GB27126@digi.com> <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208860018.4620.100.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208860018.4620.100.camel@moss.renham>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:26:57PM +1000, Ben Nizette wrote:
> 
> >   - some code could be shared with uio_smx.c
> >     I would address that in a seperate patch after this one hits mainline.
> 
> As I said before I'd prefer to keep my driver separate and standalone,
> but you and HJK have expressed a wish for unification.

This seems to be a misunderstanding. Actually, I don't care too much. If
you like to keep your driver standalone, I don't have objections, even
if Uwe's generic driver is merged. I think there are still valid reasons
not to reduce a driver to a platform data struct.

Greg, what do you say to that?

Thanks,
Hans

