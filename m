Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXBNT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXBNT0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbXBNT0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:26:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45697 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbXBNT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:26:25 -0500
Subject: Re: Linus' laptop and Num lock status
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dax Kelson <dax@gurulabs.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	 <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Feb 2007 20:26:12 +0100
Message-Id: <1171481172.12771.450.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 11:12 -0800, Linus Torvalds wrote:
> 
> On Wed, 14 Feb 2007, Dax Kelson wrote:
> > 
> > Are there any technical or political reasons why kernel can't change
> > from "force off" to "Follow BIOS"?
> 
> How would you query it? I'm not even 100% sure that you can on all 
> keyboards. We never query the leds, we always set them. I think. I don't 
> know of any AT kbd command to read the led state out of the keyboard.

and if there was one.. wanne take bets on how well it works with the
various SMM emulated USB keyboards out there? ;)


