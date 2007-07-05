Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXGEApe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXGEApe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbXGEAou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:44:50 -0400
Received: from ozlabs.org ([203.10.76.45]:57689 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbXGEAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:44:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.15209.274437.471074@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:29:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041717.05149.rjw@sisk.pl>
References: <20070703211227.GA28758@srcf.ucam.org>
	<E1I666o-0006wu-00@dorka.pomaz.szeredi.hu>
	<200707041703.21808.oliver@neukum.org>
	<200707041717.05149.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> They will not trigger 100% of the time, but sporadically and generally at
> random.
> 
> At least the freezer problems are reproducible. ;-)

Our experience with powermacs has been that it isn't actually all that
hard to get it right for the drivers you care about.

Paul.
