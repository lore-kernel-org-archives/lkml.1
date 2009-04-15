Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZDOVXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZDOVXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZDOVXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:23:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57975
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbZDOVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:23:35 -0400
Date: Wed, 15 Apr 2009 14:23:26 -0700 (PDT)
Message-Id: <20090415.142326.97287514.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davej@redhat.com
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904151013260.4132@localhost.localdomain>
	<49E62BD5.6090508@zytor.com>
	<alpine.LFD.2.00.0904151241490.4132@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Apr 2009 12:43:02 -0700 (PDT)

> And if it _is_ obvious, then the mechanical "Impact:" thing is pointless.
> 
> In other words - in neither case does it actually help anything at all. 
> It's only distracting noise.

FWIW I find the Impact: blurbs highly annoying too.  Just freakin'
say what the damn patch does in the commit message.

If a person can't be bothered to skim the commit message text,
this Impact: tag only gives them a false sense of understanding
what the change does.
