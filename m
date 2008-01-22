Return-Path: <linux-kernel-owner+w=401wt.eu-S1761028AbYAVKn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbYAVKn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYAVKnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:43:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:36558 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757330AbYAVKnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:43:46 -0500
Date: Tue, 22 Jan 2008 11:43:40 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux and remote control device
Message-ID: <20080122104340.GA6921@suse.cz>
References: <38b2ab8a0801220001t284c41bdo42b534599249df2a@mail.gmail.com> <20080122081931.GC5591@suse.cz> <38b2ab8a0801220147g15aba253g663a697c80b90397@mail.gmail.com> <20080122101415.GD6323@suse.cz> <38b2ab8a0801220220j250852e4y7b34c806dd4e72f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0801220220j250852e4y7b34c806dd4e72f5@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 11:20:53AM +0100, Francis Moreau wrote:

> > It would still limit the IR ability to sending/receiving "just"
> > keypresses. You may want to send and receive more (arbitrary data) over
> > an IR dongle attached to the machine.
> 
> Don't know about such devices. The device I actually have, an infrared
> remote control, seems simple enough to use the input device model. I
> have a wheel on it but I think I can make it work too...
 
Yes, wheel isn't a problem. I should have said 'input events'.

-- 
Vojtech Pavlik
Director SuSE Labs
