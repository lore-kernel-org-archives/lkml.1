Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYHGM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYHGM2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYHGM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:26:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56013
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbYHGM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:26:47 -0400
Date: Thu, 07 Aug 2008 05:26:48 -0700 (PDT)
Message-Id: <20080807.052648.239243998.davem@davemloft.net>
To: gitster@pobox.com
Cc: peterz@infradead.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.6.0-rc2
From: David Miller <davem@davemloft.net>
In-Reply-To: <7v3alhjgau.fsf@gitster.siamese.dyndns.org>
References: <7vskthll6t.fsf@gitster.siamese.dyndns.org>
	<1218099517.8625.3.camel@twins>
	<7v3alhjgau.fsf@gitster.siamese.dyndns.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 07 Aug 2008 03:00:25 -0700

> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > Quick question - where does one go to find out the cool new features
> > that make it 1.6 and should convince me to upgrade and try this whicked
> > new release?
> 
> Draft release notes for 1.6.0 was posted to the list some time ago
> already, but as always:
> 
>     http://www.kernel.org/pub/software/scm/git/docs/RelNotes-1.6.0.txt

Just FYI, I have some issue with 1.6.x git when pulling remotely from
it on sparc64.  I suspect it is the usual unaligned access issue and I
will debug it further soon.
