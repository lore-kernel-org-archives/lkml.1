Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXAaLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXAaLDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXAaLDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:03:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:53695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXAaLDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:03:16 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Wed, 31 Jan 2007 12:03:22 +0100
User-Agent: KMail/1.9.1
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
References: <20061219185223.GA13256@srcf.ucam.org> <200701301947.11181.oliver@neukum.name> <Pine.LNX.4.64.0701311151190.9448@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0701311151190.9448@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311203.23090.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 11:55 schrieb Jiri Kosina:
> On Tue, 30 Jan 2007, Oliver Neukum wrote:
> 
> > > Is there any hardware independent alternative to turn off USB devices?
> > Would you test a patch for autosuspension of hid devices?
> 
> Hi Oliver,
> 
> do you have such patch already? I would also like to see it; if it looks 
> OK, I will push it to -mm through my tree for wider testing.

It started working ten minutes ago and is not in a nice state now.
But you'll get it today.

	Regards
		Oliver
