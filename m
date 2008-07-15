Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYGORYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYGORYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYGORYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:24:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296AbYGORYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:24:14 -0400
Date: Tue, 15 Jul 2008 10:23:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Fix endianity in A100U2W SCSI driver
In-Reply-To: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0807151018170.3017@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Mikulas Patocka wrote:
> 
> Support big endian systems.

Hmm. Your email seems whitespace-corrupted.

It's a strange form of corruption, where a line that should start with a 
single space and a tab (normal for a patch) seems to have _two_ spaces and 
a tab. Empty lines with just a space have also had their space removed.

You seem to be a pine user (good man - but you may want to update to 
'alpine' these days and enjoy the much improved multi-charset support), 
but you also have "format=flowed", and I suspect that's related to the 
problem.

So please check the config option that says "quell flowed text", and make 
sure that "no strip whitespace before send" is also set.

I'll drop the patches, please re-send.

		Linus
