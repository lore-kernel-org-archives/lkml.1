Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbYGaAbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYGaAbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762310AbYGaA1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:27:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762301AbYGaA1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:27:49 -0400
Date: Wed, 30 Jul 2008 17:05:02 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: -stable queues flushed out, missing anything?
Message-ID: <20080731000501.GA13477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With the review cycles of 2.6.25 and 2.6.26 -stable kernels underway
right now, this is just a short note saying that all of the patches that
I have in the -stable queues have been included in these releases.

So, if I've missed anything that people have sent in the past that they
felt should be included in the .26 or .25 -stable kernel trees, please
resend them to the stable@kernel.org address (git commit id describing
the patch that is currently in Linus's tree is a requirement.)

And as always, the easiest way to get patches into the -stable tree is
to just add a simple:
	Cc: stable <stable@kernel.org>
to the Signed-off-by: area in a patch.  When it goes into Linus's tree,
the -stable team will be automatically notified of this and the patch
will then be merged into our trees as well.

thanks,

greg "finally flushed that mbox out" k-h
