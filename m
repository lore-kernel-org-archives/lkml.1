Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXJZJYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXJZJYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbXJZJYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:24:20 -0400
Received: from namei.org ([69.55.235.186]:40488 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756499AbXJZJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:24:19 -0400
Date: Fri, 26 Oct 2007 19:24:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: John Johansen <jjohansen@suse.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 34/45] Factor out sysctl pathname code
In-Reply-To: <20071026064051.683819583@suse.de>
Message-ID: <Xine.LNX.4.64.0710261923300.27480@us.intercode.com.au>
References: <20071026064024.243943043@suse.de> <20071026064051.683819583@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, jjohansen@suse.de wrote:

> Convert the selinux sysctl pathname computation code into a standalone
> function.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: John Johansen <jjohansen@suse.de>

Reviewed-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
