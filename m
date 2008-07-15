Return-Path: <linux-kernel-owner+w=401wt.eu-S1763748AbYGOVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763748AbYGOVTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYGOVRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:17:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55753 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762759AbYGOVRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:17:53 -0400
Message-ID: <487D13F3.7020304@garzik.org>
Date: Tue, 15 Jul 2008 17:17:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>	 <20080714164119.99c33d5b.akpm@linux-foundation.org>	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>	 <487C0365.5030203@garzik.org>	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>	 <200807151757.10626.elendil@planet.nl>	 <1216149637.27242.65.camel@violet.holtmann.net>	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>	 <1216150616.27455.377.camel@shinybook.infradead.org>	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>	 <1216151640.27242.90.camel@violet.holtmann.net>	 <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <1216153270.27242.110.camel@violet.holtmann.net>
In-Reply-To: <1216153270.27242.110.camel@violet.holtmann.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> And as David mentioned multiple times, he left drivers/{net,scsi} out of
> it for now.

True, but we obviously must consider them -- and booting-related 
implications -- since that is the obvious direction everybody is headed 
towards.

	Jeff


