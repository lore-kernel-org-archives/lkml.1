Return-Path: <linux-kernel-owner+w=401wt.eu-S1946257AbXBIJc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946257AbXBIJc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946259AbXBIJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:32:26 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:37880 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946257AbXBIJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:32:25 -0500
Message-ID: <45CC3F58.7010105@student.ltu.se>
Date: Fri, 09 Feb 2007 10:31:04 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: akpm@osdl.org, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert pci_module_init() to pci_register_driver()
References: <20070209071807.14937.72272.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20070209071807.14937.72272.sendpatchset@thinktank.campus.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson wrote:
> Convert pci_module_init() to pci_register_driver().
>
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested with "allyes", "allmod" & "allno" on i386
> Diff'ed against the unpatched object-files, no difference
> Has previously been sent to the maintainers, without respons
>
>  crypto/geode-aes.c |    2 +-
>  scsi/megaraid.c    |    2 +-
>  scsi/tmscsim.c     |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>   
Sorry about the re-post. It became a thread of the old mail (from 21 
Jan) so I didn't see it and thought it got lost.

Richard Knutsson

