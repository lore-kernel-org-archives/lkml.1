Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYGOXW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYGOXW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYGOXWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:22:20 -0400
Received: from namei.org ([69.55.235.186]:42128 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753387AbYGOXWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:22:19 -0400
Date: Wed, 16 Jul 2008 09:13:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Subject: Re: [PATCH 1/5] integrity: TPM cleanup
In-Reply-To: <1215467789.27626.3.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
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
> 	Patch 4/5 integrity: Linux Integrity Module(LIM)
> 	Patch 5/5 integrity: IMA as an integrity service provider
>  
> Signed-off-by: Debora Velarde <dvelarde@us.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

There's been no further comments on this patchset and it's had quite a lot 
of review.  Do you feel it's ready for merging upstream?

If you wish, I can apply this to the security-testing tree which will feed 
into linux-next and then 2.6.27.  (Generating a new patchset against 
recent Linus would likely be best).


- James
-- 
James Morris
<jmorris@namei.org>
