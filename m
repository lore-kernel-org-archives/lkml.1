Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbXAaK4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbXAaK4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXAaK4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:56:10 -0500
Received: from twin.jikos.cz ([213.151.79.26]:48280 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbXAaK4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:56:08 -0500
Date: Wed, 31 Jan 2007 11:55:44 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Oliver Neukum <oliver@neukum.name>
cc: Eric Piel <Eric.Piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
In-Reply-To: <200701301947.11181.oliver@neukum.name>
Message-ID: <Pine.LNX.4.64.0701311151190.9448@twin.jikos.cz>
References: <20061219185223.GA13256@srcf.ucam.org> <20070127131728.GB3942@ucw.cz>
 <45BF91CA.9030609@tremplin-utc.net> <200701301947.11181.oliver@neukum.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Oliver Neukum wrote:

> > Is there any hardware independent alternative to turn off USB devices?
> Would you test a patch for autosuspension of hid devices?

Hi Oliver,

do you have such patch already? I would also like to see it; if it looks 
OK, I will push it to -mm through my tree for wider testing.

Thanks,

-- 
Jiri Kosina
