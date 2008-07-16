Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYGPA30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYGPA30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYGPA3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:29:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbYGPA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:29:15 -0400
Date: Tue, 15 Jul 2008 17:28:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: david@lang.hm, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <200807160222.40705.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Frans Pop wrote:
> 
> Where did you get this strange notion that mkinitrd is the _only_ (your 
> emphasis) thing people use?

Heh. Maybe from the fact that I don't personally use modules or initrd at 
all, and have no interest in doing so ;)

Ok, so people use other things. Grr. I guess we can't just require updated 
tools, because we don't know what the tools are.

			Linus
