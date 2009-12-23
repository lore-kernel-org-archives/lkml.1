Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZLWWrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZLWWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZLWWrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:47:16 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:43291 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZLWWrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:47:15 -0500
Date: Wed, 23 Dec 2009 17:46:38 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
In-reply-to: <4B312FA9.1020301@kernel.org>
Message-id: <alpine.LFD.2.00.0912231742410.6541@localhost.localdomain>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
 <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
 <alpine.LFD.2.00.0912212107560.5520@localhost.localdomain>
 <4B3035B0.9030303@kernel.org>
 <alpine.LFD.2.00.0912220253080.7435@localhost.localdomain>
 <4B307C4D.501@kernel.org>
 <alpine.LFD.2.00.0912221440440.5153@localhost.localdomain>
 <4B312F09.5020602@kernel.org> <4B312FA9.1020301@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
Len Brown, Intel Open Source Technology Center

ps. a syntax note...
For patches like these, that are in response to list discussion,
please continue sending them as a reply to the list discussion,
but please put them in standard [PATCH] format, including
Subject appropriate for check-in summary; and exclude the
discussion context; as we don't want/need to check that into git.


