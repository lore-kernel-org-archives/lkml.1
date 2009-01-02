Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZABJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZABJLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbZABJLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:11:08 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48765 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbZABJLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:11:07 -0500
Date: Fri, 2 Jan 2009 10:12:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3]: Convert mkcapflags.pl to mkcapflags.sh
Message-ID: <20090102091236.GC3057@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020215.37223.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901020215.37223.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:15:36AM -0600, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Convert kernel/cpu/mkcapflags.pl to kernel/cpu/mkcapflags.sh.
> 
> This script generates kernel/cpu/capflags.c from include/asm/cpufeature.h.
OK

> Peter Anvin added this perl to 2.6.28.
Drop it.

Implementation looks OK.

	Sam
