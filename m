Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbXISTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbXISTmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXISTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:41:55 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:60551 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbXISTlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:41:53 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46F17B54.6070106@am.sony.com>
Date: Wed, 19 Sep 2007 12:41:08 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>,
       john cooper <john.cooper@third-harmonic.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <p73fy1av4jc.fsf@bingen.suse.de>
In-Reply-To: <p73fy1av4jc.fsf@bingen.suse.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 19:41:35.0448 (UTC) FILETIME=[167B9D80:01C7FAF5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Tim Bird <tim.bird@am.sony.com> writes:
>
>
>> Recently, the CE Linux forum has been working to revive the
>> Linux-tiny project.  At OLS, I asked for interested parties
>> to volunteer to become the new maintainer for the Linux-tiny patchset.
>
> Not sure what the point is of a separate patchkit. If it's a reasonable
> patch it should just be put into mainline. And hopefully all the patches
> will be reasonable.

I don't know the detailed history, but my understanding is that
for some of these, mainline attempts were made in the past.

The patchkit gives a place for things to live while they are out
of mainline, and still have multiple people use and work on them.
Optimally the duration of being out-of-mainline would be short, but
my experience is that sometimes what an embedded developer considers
reasonable to hack off the kernel is not considered so reasonable by
other developers (even with config options).  Also, sometimes it
takes a while for a patch to mature to the point where it is
acceptable for general use, while still being usable for
special-purpose projects.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

