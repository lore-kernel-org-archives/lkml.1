Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYFXGHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYFXGHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbYFXGHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:07:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:60254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbYFXGHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:07:03 -0400
Date: Mon, 23 Jun 2008 23:04:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
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
Message-ID: <20080624060429.GA2519@suse.de>
References: <20080623225737.837265824@mini.kroah.org> <20080623230452.GD29853@suse.de> <alpine.LFD.1.10.0806231627440.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806231627440.2926@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 04:28:24PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Jun 2008, Greg KH wrote:
> > 
> > Note, I had to merge this patch by hand, can someone verify that I 
> > didn't mess it up?
> 
> Looks ok to me.

Ah, great, thanks for checking.

greg k-h
