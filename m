Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbXEXKHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbXEXKHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXEXKG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:06:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42164 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXEXKGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:06:55 -0400
Message-ID: <465563B4.5040301@garzik.org>
Date: Thu, 24 May 2007 06:06:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable
 cycle
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070524100455.GB7444@ucw.cz>
In-Reply-To: <20070524100455.GB7444@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Well, in 2.6.73.1 we add 'trivial' one line to add new pci id, and in
> 2.6.73.2 we have data corruption, because that driver needed some
> quirk we did not know about...?

False argument.  -stable should only be merging patches that are already 
upstream, and known.

	Jeff


