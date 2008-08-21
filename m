Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbYHUS7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbYHUS7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYHUS6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:58:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46375 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751624AbYHUS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:58:47 -0400
Date: Thu, 21 Aug 2008 14:58:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: How do I raise the priority of one thread in a multi-threaded process?
Message-ID: <Pine.LNX.4.44L0.0808211414220.14466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone tell me how to raise the priority of one thread in a
multi-threaded process (using the pthreads library)?  Neither nice(2)
nor setpriority(2) is appropriate since they affect the priority of an
entire process rather than a single thread.

Thanks,

Alan Stern

