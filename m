Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYGPUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYGPUFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYGPUFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:05:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45708 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYGPUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:05:03 -0400
Subject: Re: [PATCH 1/5] integrity: TPM cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
In-Reply-To: <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com>
	 <1215467789.27626.3.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 16:04:44 -0400
Message-Id: <1216238684.5886.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 09:13 +1000, James Morris wrote: 
> On Mon, 7 Jul 2008, Mimi Zohar wrote:
> 
> > This patchset contains 5 patches.
> > 	Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
> > 	Patch 2/5 integrity: TPM internal kernel interface
> > 	Patch 3/5 integrity: special fs magic
> > 	Patch 4/5 integrity: Linux Integrity Module(LIM)
> > 	Patch 5/5 integrity: IMA as an integrity service provider
> >  
> > Signed-off-by: Debora Velarde <dvelarde@us.ibm.com>
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> There's been no further comments on this patchset and it's had quite a lot 
> of review.  Do you feel it's ready for merging upstream?

Yes, definitely!

> If you wish, I can apply this to the security-testing tree which will feed 
> into linux-next and then 2.6.27.  (Generating a new patchset against 
> recent Linus would likely be best).

Thank you, that would be wonderful.  I'll post a new patchset against 
the 2.6.26-git3.

Thanks!

Mimi

