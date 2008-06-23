Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYFWXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYFWXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYFWXbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:31:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYFWXbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:31:10 -0400
Date: Mon, 23 Jun 2008 16:28:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 10/10] Fix ZERO_PAGE breakage with vmware
In-Reply-To: <20080623230452.GD29853@suse.de>
Message-ID: <alpine.LFD.1.10.0806231627440.2926@woody.linux-foundation.org>
References: <20080623225737.837265824@mini.kroah.org> <20080623230452.GD29853@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2008, Greg KH wrote:
> 
> Note, I had to merge this patch by hand, can someone verify that I 
> didn't mess it up?

Looks ok to me.

		Linus
