Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbYGHBds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbYGHBds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 21:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYGHBd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 21:33:29 -0400
Received: from namei.org ([69.55.235.186]:41045 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757377AbYGHBd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 21:33:28 -0400
Date: Tue, 8 Jul 2008 11:33:04 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Subject: Re: [PATCH 1/5] integrity: TPM cleanup
In-Reply-To: <1215467789.27626.3.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0807081122390.10307@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com>
 <1215467789.27626.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Mimi Zohar wrote:

> This patchset contains 5 patches.
> 	Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
> 	Patch 2/5 integrity: TPM internal kernel interface
> 	Patch 3/5 integrity: special fs magic

I've previously reviewed and added "Reviewed-by:" lines for the above.

If the patches have not changed significantly, would you please ensure 
that the Reviewed-by/Acked-by/Signed-off lines are captured with them for 
subsequent postings ?

If the patches have changed and you've dropped these lines, please note 
what has changed.

It's also a good idea to cc people who have reviewed previous versions or 
postings of the patches when you repost them.


- James
-- 
James Morris
<jmorris@namei.org>
