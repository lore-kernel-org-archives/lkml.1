Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbXA0SLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbXA0SLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXA0SLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:11:22 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63826 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXA0SLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:11:21 -0500
Date: Sat, 27 Jan 2007 13:11:16 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Martin J. Bligh" <mbligh@mbligh.org>, Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@eecs.ku.edu>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic primitives
Message-ID: <20070127181116.GA5158@Krystal>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca> <20070127021834.e26e955d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070127021834.e26e955d.akpm@osdl.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 13:10:02 up 157 days, 15:17,  3 users,  load average: 1.04, 0.63, 0.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@osdl.org) wrote:
> I'm giving up.  Someone should publish a suite of cross-compilers for us
> so stuff like this doesn't need to happen.

Hi Andrew,

I am currently trying crosstool by Dan Kegel, it looks promising.
http://www.kegel.com/crosstool/

I will let you know more when my cross compiler chain is set up.

Mathieu


-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
