Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXCaPuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXCaPuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 11:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXCaPuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 11:50:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbXCaPux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 11:50:53 -0400
Message-ID: <460E835A.4000300@redhat.com>
Date: Sat, 31 Mar 2007 11:50:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Pedram M <pmessri@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fwd: kswapd issues + kernel 2.4.21-32.0.1.ELsmp
References: <9c9aa5d00703310110s2a21f19l37544c3d46be53c9@mail.gmail.com> <9c9aa5d00703310111w3809fd56t75bcde9d5047ca81@mail.gmail.com>
In-Reply-To: <9c9aa5d00703310111w3809fd56t75bcde9d5047ca81@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pedram M wrote:
> Hi,
> 
> I've seen this around, and have heard about it in forums and else-where,
> could somebody enlighten me with more information or with experiences
> they have had.  Looks like kswapd begins to eat CPU dramatically till the
> box eventually locks up.

You'll want to contact your distro's support people, who are way
better than I am at extracting all the information needed to
debug your problem.

OTOH, chances are it's been fixed already in a more recent kernel.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
