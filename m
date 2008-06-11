Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYFKLGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYFKLGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 07:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYFKLFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 07:05:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1889 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754633AbYFKLFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 07:05:35 -0400
Date: Wed, 11 Jun 2008 12:53:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] AMD Family10h+ IBS support for oProfile driver: buffer management
Message-ID: <20080611105345.GF5612@ucw.cz>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain> <20080609175052.2844.12167.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609175052.2844.12167.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon 2008-06-09 13:50:48, Barry Kasindorf wrote:
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> 

missing changelog, lots of strange whitespace changes.

> @@ -33,7 +34,7 @@
>  #include "event_buffer.h"
>  #include "cpu_buffer.h"
>  #include "buffer_sync.h"
> -
> +
>  static LIST_HEAD(dying_tasks);
>  static LIST_HEAD(dead_tasks);
>  static cpumask_t marked_cpus = CPU_MASK_NONE;

I actually do not see the difference here. What is going on?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
