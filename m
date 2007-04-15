Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXDORPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXDORPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDORPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:15:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:31757 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXDORPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pqIn9HC2XZap6Uny8vvVwObvY/P0FO2wX2pUw2yyHQWppaS+z6k32/0NChTQceokYspUaMIKxGqQqULQNHMHgQ4waqajv/mTXunkdN4ExVgXPkfsv0OB7KfUmqXYT4U9LCBpSjWa73ccGrTQl+9qJEnbqNNX/eEV21gYUUcGiEA=
Message-ID: <b6a2187b0704151015x350b2d76gbde63d8351cc6812@mail.gmail.com>
Date: Mon, 16 Apr 2007 01:15:39 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Dave Jones" <davej@redhat.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Tobias Doerffel" <tobias.doerffel@gmail.com>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Marcus Better" <marcus@better.se>, adaplas@gmail.com,
       "James Simmons" <jsimmons@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20070414003808.GU5907@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <20070414003808.GU5907@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/07, Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/3/25/217
> Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

Still hangs on -rc6.

Thanks,
Jeff.
