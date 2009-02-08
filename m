Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZBHQf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZBHQf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZBHQfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:35:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35734 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZBHQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:35:46 -0500
Date: Sun, 8 Feb 2009 11:35:45 -0500
To: George Spelvin <linux@horizon.com>
Cc: LinuxPPS@ml.enneenne.com, linux-kernel@vger.kernel.org,
       giometti@enneenne.com
Subject: Re: LinuxPPS kernel interface
Message-ID: <20090208163545.GB15809@csclub.uwaterloo.ca>
References: <20090206142231.22425.qmail@science.horizon.com> <20090206143703.GC7975@enneenne.com> <20090206144752.5195.qmail@science.horizon.com> <20090206145553.GD7975@enneenne.com> <20090206145932.10638.qmail@science.horizon.com> <20090206152156.GE7975@enneenne.com> <20090206225326.14093.qmail@science.horizon.com> <20090208004914.21448.qmail@science.horizon.com> <20090208015633.GA15809@csclub.uwaterloo.ca> <20090208040018.10831.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208040018.10831.qmail@science.horizon.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 11:00:18PM -0500, George Spelvin wrote:
> Er, yes, I'm sorry if I left out that bit of background; I had meant to
> imply it when I mentioned "LinuxPPS" in the subject line, which I think
> of as Rodolfo's code base.  I was starting from that implementation,
> my patches were to that code, and I was thinking about further changes.

Oh OK.  Well in that case have fun.  I am pretty sure the existing code
already does much of what you mentioned.  I certainly have been using
DCD input on serial ports with the code and it works very well.

> It's not; I've been working on improvements to Rodolfo's code.
> (For example, I think the PPS_FETCH ioctl interface could use it.)

Oh OK.  Great idea then.

-- 
Len Sorensen
