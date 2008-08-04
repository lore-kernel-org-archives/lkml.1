Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYHDAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYHDAXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYHDAXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:23:32 -0400
Received: from namei.org ([69.55.235.186]:55025 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753142AbYHDAXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:23:31 -0400
Date: Mon, 4 Aug 2008 10:23:12 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com
Subject: Re: [Patch]integrity: ima policy update patch
In-Reply-To: <1217618432.3401.3.camel@new-host-2.home>
Message-ID: <Xine.LNX.4.64.0808041022170.19616@us.intercode.com.au>
References: <1217618432.3401.3.camel@new-host-2.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Mimi Zohar wrote:

> - This patch adds support for policy definitions defined in terms of
>   LSM subj_role, subj_type, and obj_role.
> - Support for uid measurement policy definitions.
> - Constrain the default INODE_PERMISSION measurement to only measure 
>   files opened for read by root.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git#devel

Please use a more descriptive subject in the future.


- James
-- 
James Morris
<jmorris@namei.org>
