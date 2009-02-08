Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZBHEA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZBHEA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 23:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZBHEAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 23:00:20 -0500
Received: from science.horizon.com ([192.35.100.1]:10790 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752483AbZBHEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 23:00:20 -0500
Message-ID: <20090208040018.10831.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sat, 07 Feb 2009 23:00:18 -0500
To: lsorense@csclub.uwaterloo.ca, linux@horizon.com
Cc: LinuxPPS@ml.enneenne.com, linux-kernel@vger.kernel.org,
       giometti@enneenne.com
Subject: Re: LinuxPPS kernel interface
References: <20081028181335.29352.qmail@science.horizon.com>
 <20081028181546.GM11339@tekkaman>
 <20090206142231.22425.qmail@science.horizon.com>
 <20090206143703.GC7975@enneenne.com>
 <20090206144752.5195.qmail@science.horizon.com>
 <20090206145553.GD7975@enneenne.com>
 <20090206145932.10638.qmail@science.horizon.com>
 <20090206152156.GE7975@enneenne.com>
 <20090206225326.14093.qmail@science.horizon.com>
 <20090208004914.21448.qmail@science.horizon.com>
 <20090208015633.GA15809@csclub.uwaterloo.ca>
In-Reply-To: <20090208015633.GA15809@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
> Have you looked at the PPS code Rodolfo Giometti has been working on and
> has been working hard to get in to the kernel?  It works very well, and
> I think probably does everything (or at least most of what) you
> mentioned.  I have been using it for a couple of years now.

Er, yes, I'm sorry if I left out that bit of background; I had meant to
imply it when I mentioned "LinuxPPS" in the subject line, which I think
of as Rodolfo's code base.  I was starting from that implementation,
my patches were to that code, and I was thinking about further changes.

> I would not start working on yet another implementation.

It's not; I've been working on improvements to Rodolfo's code.
(For example, I think the PPS_FETCH ioctl interface could use it.)
