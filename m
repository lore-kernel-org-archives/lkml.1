Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZBKJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZBKJp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZBKJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:45:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZBKJpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:45:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
Date: Wed, 11 Feb 2009 10:44:57 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org
References: <200902110036.n1B0aBZs013975@imap1.linux-foundation.org> <49928FDB.5020007@gmail.com>
In-Reply-To: <49928FDB.5020007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111044.57869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Jiri Slaby wrote:
> On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded
> 
> Hi,
> 
> when I resume from suspend, USB mouse and kbd are not responding anymore, no
> LEDs, nothing. I need to unplug and replug to get it working. This is a
> regression since mmotm based on 2.6.29-rc2 which is fine.
> 
> Any ideas before I start bisection?

Please test current mainline, it may be a regression in there.

How exactly are the failing devices connected to the box?

Rafael
