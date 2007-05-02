Return-Path: <linux-kernel-owner+w=401wt.eu-S2993048AbXEBL16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993048AbXEBL16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993049AbXEBL16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:27:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:48852 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993048AbXEBL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:27:57 -0400
To: Christian Schmidt <lkml@digadd.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory consumption on linux
References: <4637958F.5010405@digadd.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 May 2007 14:25:29 +0200
In-Reply-To: <4637958F.5010405@digadd.de>
Message-ID: <p73odl3xvie.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schmidt <lkml@digadd.de> writes:

> Global cache is easy to understand - file system / inode caches. What
> exactly is buffers, though?

http://www.halobates.de/memorywaste.pdf and http://www.halobates.de/memory.pdf
give some overview of in kernel memory users.

-Andi

