Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXDLQsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXDLQsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXDLQsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:48:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:55776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXDLQrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:47:36 -0400
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Christopher S. Aker" <caker@theshore.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Apr 2007 19:45:52 +0200
In-Reply-To: <20070412164251.GC11736@ti88.telemetry-investments.com>
Message-ID: <p73ps697agf.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Bill Rugolsky Jr." <brugolsky@telemetry-investments.com> writes:
> 
> The current functionality doesn't parse command line arguments into argv,
> nor provide the % variable replacements in the environment, so it is
> somewhat less useful than it could be. 

That was intentional because all this information is in the core dump itself
or in the environment.

-Andi
