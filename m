Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXHCOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXHCOXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbXHCOXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:23:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762083AbXHCOXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:23:13 -0400
Date: Fri, 3 Aug 2007 10:22:55 -0400
From: Dave Jones <davej@redhat.com>
To: David Brownell <david-b@pacbell.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803142255.GA11942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Brownell <david-b@pacbell.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de> <20070803014756.GA10392@srcf.ucam.org> <200708022306.08410.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708022306.08410.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 11:06:08PM -0700, David Brownell wrote:
 
 > Sometimes when I plug in a USB device I get a dialog asking if I want to
 > configure it ... surely it would be possible to have that mechanism also
 > consult a database (part of a distro, or on some web server) fpr info
 > about the device, and offer the option for to poke at the device a bit to
 > see if it behaves.  That stuff works for music CDs; why not USB devices?

Not everyone who uses USB devices uses X.
It's a bit difficult to pop up a "unscrew my printer" dialog when you're
on the console.

	Dave

-- 
http://www.codemonkey.org.uk
