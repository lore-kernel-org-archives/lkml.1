Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbYF3JSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbYF3JSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYF3JSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:18:24 -0400
Received: from namei.org ([69.55.235.186]:51041 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbYF3JSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:18:23 -0400
Date: Mon, 30 Jun 2008 19:13:15 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Debora Velarde <dvelarde@us.ibm.com>
Subject: Re: [RFC][PATCH 1/5] integrity: TPM cleanup
In-Reply-To: <1214583735.28077.14.camel@new-host.home>
Message-ID: <Xine.LNX.4.64.0806301912510.23266@us.intercode.com.au>
References: <20080627131946.225566613@linux.vnet.ibm.com>
 <1214583735.28077.14.camel@new-host.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Mimi Zohar wrote:

> This is a request for comments for a redesign of the integrity patches.
> This patchset contains 5 patches.
> 	Patch 1/5 integrity: TPM cleanup (scripts/Lindent and other)
> 	Patch 2/5 integrity: TPM internal kernel interface
> 	Patch 3/5 integrity: special fs magic
> 	Patch 4/5 integrity: Linux Integrity Module(LIM)
> 	Patch 5/5 integrity: IMA as an integrity service provider
>  
> Signed-off-by: Debora Velarde <dvelarde@us.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
