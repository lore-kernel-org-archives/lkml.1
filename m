Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYHUQH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYHUQH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYHUQHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:07:48 -0400
Received: from torres.zugschlus.de ([85.214.68.41]:46352 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYHUQHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:07:47 -0400
Date: Thu, 21 Aug 2008 18:07:46 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Boot failures on Qemu due to P6_NOPS
Message-ID: <20080821160746.GA21967@torres.zugschlus.de>
References: <20080707172334.GH1009@lisa.in-ulm.de> <48725A16.6010307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48725A16.6010307@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 11:01:58AM -0700, H. Peter Anvin wrote:
> It is a Qemu bug.  Microsoft Virtual Server 2005 have it too.
> 
> One *major* problems with virtualizers is that they uniformly use an 
> existing CPU identifier, even though they might have their own sets of 
> bugs.  This makes it much harder to work around bugs in them.

But it would be possible to have kernel command line options to enable
the workarounds. Having this would be great to enhance Linux'
compatibility.

For people who are uniformly using Microsoft, Linux not running on
Virtual Server is a Linux problem, and they're going to ditch Linux if
it doesn't run there.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
