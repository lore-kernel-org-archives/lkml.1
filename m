Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZJRWdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZJRWdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJRWdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:33:04 -0400
Received: from foo.birdnet.se ([213.88.146.6]:50418 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754231AbZJRWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:33:03 -0400
Message-ID: <20091018223306.17571.qmail@stuge.se>
Date: Mon, 19 Oct 2009 00:33:06 +0200
From: Peter Stuge <peter@stuge.se>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Adding an ioctl or three
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <20091015205803.30544.qmail@stuge.se> <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk> <20091015214642.6208.qmail@stuge.se> <20091015230853.44fb10c1@lxorguk.ukuu.org.uk> <20091018162737.18611.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018162737.18611.qmail@stuge.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Stuge wrote:
> Is patching Documentation/ioctl/ioctl-number.txt and
> asm/ioctls.h all?

I added an ioctl into a header of my own. It works fine, but..


> The "addressing" in ioctl-number seems a little chaotic, do I just
> pick anything that is available?

Documentation/ioctl/ioctl-number.txt seems out of date. I picked
a number that was used (by linux/toshiba.h) but not listed. Do I have
to grep it out?


//Peter
