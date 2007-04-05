Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXDECpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXDECpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 22:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161001AbXDECpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 22:45:08 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:41637 "EHLO
	asav08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160993AbXDECpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 22:45:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMAKj/E0ZKhRO4UGdsb2JhbACHNohCAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH 11/90] ARM: OMAP: Add support for Amstrad Delta keypad
Date: Wed, 4 Apr 2007 22:45:04 -0400
User-Agent: KMail/1.9.3
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <d120d5000704041357r1dd813c6k33676dfdc44b86c5@mail.gmail.com> <20070404220556.GG5188@earth.li>
In-Reply-To: <20070404220556.GG5188@earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704042245.05233.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 18:05, Jonathan McDowell wrote:
> On Wed, Apr 04, 2007 at 04:57:57PM -0400, Dmitry Torokhov wrote:
> > On 4/4/07, Tony Lindgren <tony@atomide.com> wrote:
> > 
> > >+       KEY(0, 7, KEY_LEFTSHIFT),       /* Vol up       */
> > 
> > KEY_VOLUMEUP?
> > 
> > >+       KEY(3, 7, KEY_LEFTCTRL),        /* Vol down  */
> > 
> > KEY_VOLUMEDOWN?
> 
> In terms of making the keypad on top of the E3 usable left shift and
> left ctrl make more sense (there are no other keys with this function
> and they are to the left of the qwerty layout), but the keys are in fact
> labelled vol up/down, hence the comments.

Ah, I see, OK.

-- 
Dmitry
