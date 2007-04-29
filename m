Return-Path: <linux-kernel-owner+w=401wt.eu-S1161411AbXD2Vai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161411AbXD2Vai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161441AbXD2Vah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:30:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161411AbXD2Vaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:30:35 -0400
Date: Sun, 29 Apr 2007 17:27:56 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Markus Rechberger <mrechberger@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429212756.GA14857@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Rechberger <mrechberger@gmail.com>,
	Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org> <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com> <alpine.LFD.0.98.0704281629440.9964@woody.linux-foundation.org> <20070429000542.GH3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429000542.GH3468@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 02:05:42AM +0200, Adrian Bunk wrote:
 > On Sat, Apr 28, 2007 at 04:40:31PM -0700, Linus Torvalds wrote:
 > >...
 > > What's the difference between bugzilla and lkml.org? Both have search 
 > > buttons. Both archive the old stuff. Both can be pointed to.
 > 
 > Mailing lists don't track bugs.

There's no reason they can't.  Store them in folders 'fixed' 'pending'
'notabug' etc. Move mails between them when states change.
reply-to them when necessary. Bounce them. Add people to Ccs. etc. etc.

The only remaining piece of the puzzle is "how does everyone see the
states of the various pools", which could be solved in a number of
ways, daily uploads to a place on kernel org for eg.

Hell, you could store them in a git tree if it came to it.
That would also solve the problem for those with an aversion
to web browsers to see bugs :-)

	Dave

-- 
http://www.codemonkey.org.uk
