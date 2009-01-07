Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbZAGU1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbZAGU1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZAGU1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:27:32 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55589 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZAGU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:27:32 -0500
Date: Wed, 7 Jan 2009 21:29:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/3] KBUILD: Add a symlink to the source for separate objdirs
Message-ID: <20090107202913.GJ4647@uranus.ravnborg.org>
References: <20090103321.351399938@firstfloor.org> <20090103022142.684153E6651@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103022142.684153E6651@basil.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 03:21:42AM +0100, Andi Kleen wrote:
> 
> I have some scripts which need to map back to the source directory
> from an objdir. This was so far done by parsing the Makefile,
> but the Makefile format changes occasionally and breaks my scripts
> then.
> 
> To make this more reliable add a "source" symlink back. 
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Like we do when we install modules. Agreed this is usefull.
Applied.

	Sam
