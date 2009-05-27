Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZE0Dae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZE0Dae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZE0Da0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:30:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:35697 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbZE0DaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:30:25 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905262210350.21274-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0905262210350.21274-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 13:30:02 +1000
Message-Id: <1243395002.17847.54.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I can't disagree with that.  :-)  The usb-serial design was a mess to 
> begin with, and it didn't get much better when the serial bus was 
> introduced.
> 
> I'm inclined to use my patch because it's shortest.  Can I add your 
> "Tested-by:"?

Just tested it. I'll send that as a reply to the patch itself.

Cheers,
Ben.


