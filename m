Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbZE0ADd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbZE0ADd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbZEZX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:58:23 -0400
Received: from mail.crca.org.au ([67.207.131.56]:44770 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761124AbZEZX6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:58:21 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <200905270024.39073.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
	 <200905270024.39073.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 10:00:10 +1000
Message-Id: <1243382410.13930.106.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2009-05-27 at 00:24 +0200, Oliver Neukum wrote:
> Am Dienstag, 26. Mai 2009 23:56:16 schrieb Alan Stern:
> > Probably the driver's author just never got around to adding support
> > for suspend/resume.  Which driver is it?  What happens if you don't
> > rmmod it?
> 
> cxusb. Indeed it does not implement suspend/resume.

Ah. Bet me to it. Yes, dvb_usb_cxusb or something like that.

Nigel

