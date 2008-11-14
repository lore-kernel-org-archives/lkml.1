Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYKNWnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYKNWnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKNWm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:42:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYKNWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:42:55 -0500
Date: Fri, 14 Nov 2008 14:42:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] edac: fix mpc85xx and add mpc8536 mpc8560
Message-Id: <20081114144253.a6f184a5.akpm@linux-foundation.org>
In-Reply-To: <491b8e5b.uSc1E4+nIKbPbwoT%dougthompson@xmission.com>
References: <491b8e5b.uSc1E4+nIKbPbwoT%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 19:18:03 -0700
dougthompson@xmission.com wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> 
> All other compatibles that are uniquely identifying the processor use
> a prefix of the form fsl,mpc85...'.  We add support for it so we
> can deprecate the older 'fsl,85...' that was improperly used here.
> 
> Additionally added mpc8536 & mpc8560 to the compatible lists.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Acked-by: Dave Jiang <djiang@mvista.com>

I don't understand how this patch changes kernel behaviour (this is due
to my ignorance and your crappy changelog).  So I randomly queued it
for 2.6.29.  If that was wrong, please let me know.

> 
> This patch is based on Nate's 8572 patch.

Who's Nate?  He should at least get a cc.  Perhaps a signed-off-by: too?

