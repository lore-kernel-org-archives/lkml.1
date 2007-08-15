Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbXHONE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbXHONE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763645AbXHONDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:03:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765194AbXHONC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:02:59 -0400
Date: Wed, 15 Aug 2007 15:57:04 +0200
From: Andi Kleen <ak@suse.de>
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] [3/4] x86_64: Change PMDS invocation to single macro
Message-ID: <20070815135704.GF3406@bingen.suse.de>
References: <20070815240.194452000@suse.de> <20070815004036.6BBCF14DC8@wotan.suse.de> <46C2F19A.30003@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C2F19A.30003@anagramm.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you please add a comment, that this line must stay in a single line
> for the above reason? I would expect that the next who does some code
> clean up will break it again.

Then we would need to add it to all macros essentially. That wouldn't
be economical.

-Andi
