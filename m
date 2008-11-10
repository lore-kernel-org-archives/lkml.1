Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYKJS2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYKJS2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYKJS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:28:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYKJS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:28:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Mon, 10 Nov 2008 19:33:25 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20081109140726.GB1786@ucw.cz> <20081110125335.GB28643@elte.hu> <878wrrpic1.fsf@basil.nowhere.org>
In-Reply-To: <878wrrpic1.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101933.26110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 of November 2008, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > i can only suggest some stupid tweaking of the above options - for 
> > example, does the bug scenario change in any way if you switch it over 
> > to CONFIG_DISCONTIGMEM=y ?
> 
> iirc we removed that some time ago so it would probably need some
> source hackery. There is only vmemmap or flat left.

No, it's there. :-)

Thanks,
Rafael
