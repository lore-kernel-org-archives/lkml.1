Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYGHMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYGHMCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYGHMBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:01:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57329 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYGHMBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:01:50 -0400
Subject: Re: [PATCH 1/5] integrity: TPM cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
In-Reply-To: <Xine.LNX.4.64.0807081122390.10307@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com>
	 <1215467789.27626.3.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0807081122390.10307@us.intercode.com.au>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 08:01:47 -0400
Message-Id: <1215518507.5013.44.camel@new-host>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-08 at 11:33 +1000, James Morris wrote: 
> On Mon, 7 Jul 2008, Mimi Zohar wrote:
> 
> > This patchset contains 5 patches.
> > 	Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
> > 	Patch 2/5 integrity: TPM internal kernel interface
> > 	Patch 3/5 integrity: special fs magic
> 
> I've previously reviewed and added "Reviewed-by:" lines for the above.
> 
> If the patches have not changed significantly, would you please ensure 
> that the Reviewed-by/Acked-by/Signed-off lines are captured with them for 
> subsequent postings ?
> 
> If the patches have changed and you've dropped these lines, please note 
> what has changed.
> 
> It's also a good idea to cc people who have reviewed previous versions or 
> postings of the patches when you repost them.
> 
> 
> - James

No, nothing has changed in the first 3 patches, except for removing 
the [RFC] in the Subject line. Thank you for pointing out the need to
capture the Reviewed-by/Acked-by/Signed-off lines and copying the reviewers.  
Will do in the future.

Mimi

