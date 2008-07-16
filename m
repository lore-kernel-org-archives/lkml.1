Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYGPAn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYGPAn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGPAnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:43:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33891 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYGPAnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:43:19 -0400
Message-ID: <487D441B.5010908@garzik.org>
Date: Tue, 15 Jul 2008 20:43:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Frans Pop <elendil@planet.nl>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 Jul 2008, Frans Pop wrote:
>> Where did you get this strange notion that mkinitrd is the _only_ (your 
>> emphasis) thing people use?
> 
> Heh. Maybe from the fact that I don't personally use modules or initrd at 
> all, and have no interest in doing so ;)
> 
> Ok, so people use other things. Grr. I guess we can't just require updated 
> tools, because we don't know what the tools are.

Yes, that's part of the problem :/

Everybody seems to love rolling their own stuff in this area, partly 
necessitated I suppose by the wide variety of ways to boot on various 
platforms.

	Jeff




