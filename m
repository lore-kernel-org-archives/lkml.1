Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZFCRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZFCRwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZFCRwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:52:11 -0400
Received: from vena.lwn.net ([206.168.112.25]:60828 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZFCRwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:52:10 -0400
Date: Wed, 3 Jun 2009 11:52:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [Bug #13325] 2.6.30-rc kills my box hard - and lockdep chains
Message-ID: <20090603115210.6a06492b@bike.lwn.net>
In-Reply-To: <LEcEO2518_I.A.vNE.TJbIKB@chimera>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	<LEcEO2518_I.A.vNE.TJbIKB@chimera>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 21:37:32 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
> Subject		: 2.6.30-rc kills my box hard - and lockdep chains
> Submitter	: Jonathan Corbet <corbet@lwn.net>
> Date		: 2009-05-14 15:49 (17 days old)
> References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4

FWIW, I'm no longer able to make this happen.  No idea what has
changed...  But it seems to be gone, and nobody else has complained, so
I guess it's a non-issue for 2.6.30.  It can probably be removed from
the list.

Thanks,

jon
