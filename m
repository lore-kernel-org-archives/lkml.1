Return-Path: <linux-kernel-owner+w=401wt.eu-S1759782AbXFUUYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbXFUUYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXFUUYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:24:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47555 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756043AbXFUUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:24:37 -0400
Date: Thu, 21 Jun 2007 13:24:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org
Subject: NUMA BOF @OLS
Message-ID: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone is invited to the NUMA BOF at the Ottawa Linux Symposium

Friday Jun 29th, 2007 19:00 - 20:00 in Rockhopper

The main interest seems to be a discussion on the use of memory policies. 
Lee Schermerhorn will talk a bit about his work and then I may say 
something about the problems with memory policies.

More subjects:

- Memoryless node support

- Restricting subsystems to not allocate on certain nodes
  (f.e. huge pages only on some nodes, slab only on some nodes,
  kernel memory only on some nodes).

- Cpusets and containers

- Do we need to have more support for multicore issues in the NUMA layers?

- Issues with the scheduler on NUMA. 

If you have another subject that should be brought up then please contact 
me.
