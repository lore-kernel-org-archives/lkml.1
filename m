Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYFKPoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYFKPoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYFKPo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:44:27 -0400
Received: from mail.suse.de ([195.135.220.2]:35659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYFKPo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:44:27 -0400
Date: Wed, 11 Jun 2008 17:45:03 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Limit E820 map and /proc/iomem for mem parameter on
 x86-64
Message-ID: <20080611174503.3e6b18e8@halley.suse.de>
In-Reply-To: <20080611153901.GD6450@redhat.com>
References: <20080610215325.GA20673@suse.de>
	<20080611153901.GD6450@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-06-11 11:39]:
>
> Also I would like to have another interface (say /proc/iomem_kernel)which
> actually gets modified based on the user specified options. So effectively we
> can have both the views. BIOS view and user defined view.

Yes, of course, I just don't have time to work full-time on that, so be
a bit patient. :)



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
