Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXLEXjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXLEXjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXLEXjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:39:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:52400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLEXjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:39:23 -0500
To: renzo@cs.unibo.it (Renzo Davoli)
Cc: linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
From: Andi Kleen <andi@firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it>
Date: Thu, 06 Dec 2007 00:39:22 +0100
In-Reply-To: <20071205164055.GA2082@cs.unibo.it> (Renzo Davoli's message of "Wed\, 5 Dec 2007 17\:40\:55 +0100")
Message-ID: <p73bq94k8yd.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renzo@cs.unibo.it (Renzo Davoli) writes:

> Berkeley socket have been designed for client server or point to point
> communication. All existing Address Families implement this idea.

Netlink is multicast/broadcast by default for once. And BC/MC certainly
works for IPv[46] and a couple of other protocols too.

> IPN is an Inter Process Communication paradigm where all the processes
> appear as they were connected by a networking bus.

Sounds like netlink. See also RFC 3549

Haven't read further I admit.

-Andi
