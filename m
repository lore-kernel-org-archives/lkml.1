Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZFDWEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZFDWEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZFDWEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:04:42 -0400
Received: from tundra.namei.org ([65.99.196.166]:55751 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZFDWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:04:42 -0400
Date: Fri, 5 Jun 2009 08:03:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, vibi sreenivasan <vibi_sreenivasan@cms.com>,
       Jiri Slaby <jirislaby@gmail.com>, Eric Paris <eparis@redhat.com>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: ima audit dentry_open failure
In-Reply-To: <1244137990-12678-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0906050803290.9543@tundra.namei.org>
References: <1244137990-12678-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Mimi Zohar wrote:

> Until we start appraising measurements, the ima_path_check()
> return code should always be 0.
> 
> - Update the ima_path_check() return code comment
> - Instead of the pr_info, audit the dentry_open failure
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
