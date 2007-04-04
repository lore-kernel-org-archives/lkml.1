Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXDDWb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXDDWb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXDDWb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:31:26 -0400
Received: from the.earth.li ([193.201.200.66]:58677 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXDDWbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:31:25 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 18:31:25 EDT
Date: Wed, 4 Apr 2007 23:05:56 +0100
From: Jonathan McDowell <noodles@earth.li>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/90] ARM: OMAP: Add support for Amstrad Delta keypad
Message-ID: <20070404220556.GG5188@earth.li>
References: <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <d120d5000704041357r1dd813c6k33676dfdc44b86c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000704041357r1dd813c6k33676dfdc44b86c5@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 04:57:57PM -0400, Dmitry Torokhov wrote:
> On 4/4/07, Tony Lindgren <tony@atomide.com> wrote:
> 
> >+       KEY(0, 7, KEY_LEFTSHIFT),       /* Vol up       */
> 
> KEY_VOLUMEUP?
> 
> >+       KEY(3, 7, KEY_LEFTCTRL),        /* Vol down  */
> 
> KEY_VOLUMEDOWN?

In terms of making the keypad on top of the E3 usable left shift and
left ctrl make more sense (there are no other keys with this function
and they are to the left of the qwerty layout), but the keys are in fact
labelled vol up/down, hence the comments.

J.

-- 
Revd. Jonathan McDowell, ULC | noodles is good in nagahama
