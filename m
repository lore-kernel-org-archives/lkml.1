Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbXGXWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbXGXWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXGXWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:45:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbXGXWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:45:58 -0400
Message-ID: <46A68118.9080902@zytor.com>
Date: Tue, 24 Jul 2007 15:45:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Ulrich Kunitz <kune@deine-taler.de>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com>
In-Reply-To: <46A68003.6060901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> 
> Okay, I tested with Fedora on x86_64 and it worked there too.
> (Not that that proves much.)
> 
> Did you capture any of the error messages, like the address
> of the segfault?
> 

FWIW, on x86-64, this should show up in dmesg.

	-hpa
