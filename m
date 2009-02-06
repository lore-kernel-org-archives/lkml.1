Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZBFQxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZBFQxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZBFQxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:53:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZBFQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:53:23 -0500
Date: Fri, 6 Feb 2009 08:53:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.29-rc
In-Reply-To: <1233937349.17551.18.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0902060851270.3048@localhost.localdomain>
References: <1233937349.17551.18.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Feb 2009, Chris Mason wrote:
> 
> Here's the shortlog:

Diffstats too, please.

Even before pulling, I want to know that some pull is supposed to only 
touch files in that persons maintenance area.

And _after_ pulling, I want to be able to verify that what I pulled is 
what the maintainer meant for me to pull.

diffstats help with those.

	git diff -M --stat --summary linus...

or just use "git request-pull" and edit up the end result.

		Linus
