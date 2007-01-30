Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXA3SrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXA3SrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbXA3SrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:47:06 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:24944 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXA3SrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:47:04 -0500
Date: Tue, 30 Jan 2007 19:47:00 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: Eric Piel <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
User-Agent: KMail/1.9.1
Cc: Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
References: <20061219185223.GA13256@srcf.ucam.org>
 <20070127131728.GB3942@ucw.cz> <45BF91CA.9030609@tremplin-utc.net>
In-Reply-To: <45BF91CA.9030609@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301947.11181.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. Januar 2007 19:43 schrieb Eric Piel:

> I have been using this interface for a _long_ time (before june 2005, cf 
> http://marc.theaimsgroup.com/?l=linux-usb-devel&m=111869558800526&w=2) 
> and for different things than power saving: I can turn off my (usb) 
> optical mouse when watching a movie or going to bed.
> 
> Is there any hardware independent alternative to turn off USB devices?

Would you test a patch for autosuspension of hid devices?

	Regards
		Oliver
