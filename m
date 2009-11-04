Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZKDPGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZKDPGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZKDPGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:06:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbZKDPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:06:48 -0500
Date: Wed, 4 Nov 2009 07:06:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Rolland <rol@witbe.net>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc6
In-Reply-To: <20091104104004.77c439e0@tux.DEF.witbe.net>
Message-ID: <alpine.LFD.2.01.0911040705560.31845@localhost.localdomain>
References: <alpine.LFD.2.01.0911031142170.31845@localhost.localdomain> <20091104104004.77c439e0@tux.DEF.witbe.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Nov 2009, Paul Rolland wrote:
> 
> It seems the patches in http://lkml.org/lkml/2009/10/18/142? are not
> included in 2.6.32-rc6

Indeed. I got the pull request yesterday evening, and they're in -git now, 
but they didn't make -rc6.

		Linus
