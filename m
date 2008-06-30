Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYF3KE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYF3KE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYF3KEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:04:51 -0400
Received: from namei.org ([69.55.235.186]:58387 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754419AbYF3KEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:04:50 -0400
Date: Mon, 30 Jun 2008 20:04:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Reiner Sailer <sailer@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 2/5] integrity: TPM internel kernel interface
In-Reply-To: <1214583756.28077.15.camel@new-host.home>
Message-ID: <Xine.LNX.4.64.0806302003300.23266@us.intercode.com.au>
References: <20080627131946.225566613@linux.vnet.ibm.com>
 <1214583756.28077.15.camel@new-host.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Mimi Zohar wrote:

> Resubmitting integrity-tpm-internal-kernel-interface.patch, which
> was previously Signed-off-by Kylene Hall.
> Updated per feedback.
> 
> Adds the following support: 
> - make internal kernel interface to transmit TPM commands global
> - adds reading a pcr value
> - adds extending a pcr value
> - adds lookup the tpm_chip for given chip number and type
> 
> Signed-off-by: Debora Velarde <debora@linux.vnet.ibm.com>


Reviewed-by: James Morris <jmorris@namei.org>




- James
-- 
James Morris
<jmorris@namei.org>
