Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbXHCO0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbXHCO0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbXHCOZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:25:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbXHCOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:25:58 -0400
Date: Fri, 3 Aug 2007 10:24:16 -0400
From: Dave Jones <davej@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by
	default on certain device classes
Message-ID: <20070803142416.GB11942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oliver Neukum <oliver@neukum.org>,
	linux-usb-devel@lists.sourceforge.net,
	Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de> <20070803014756.GA10392@srcf.ucam.org> <200708030957.46320.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708030957.46320.oliver@neukum.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 09:57:45AM +0200, Oliver Neukum wrote:
 
 > Kernel developers are a diverser lot than you think ;-)
 > We don't enable autosuspend in drivers we can't test, except where
 > the lack of a kernel driver forces us to use a broad swipe. Printers
 > were tested, too, and most printers seem to work.

My experience suggests the opposite.  Of the several I've tried so far,
none have worked with usb suspend.

	Dave

-- 
http://www.codemonkey.org.uk
