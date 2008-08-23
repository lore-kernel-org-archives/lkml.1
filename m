Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYHWSak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYHWSak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 14:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYHWSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 14:30:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3023 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753266AbYHWSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 14:30:17 -0400
Date: Sat, 23 Aug 2008 14:30:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
In-Reply-To: <200808231028.03802.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0808231427500.22958-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008, Andrey Borzenkov wrote:

> If you are still interested in this strange effect of lone 38b375d9,
> I could run some tests; just tell me what is needed.

I'm not really concerned with theoretical intermediate states.  So long
as your system is okay with the final state and the actual intermediate 
versions of the kernel (other than the 2.6.26-rc form which we already 
know causes problems), then I'm happy.

Alan Stern

