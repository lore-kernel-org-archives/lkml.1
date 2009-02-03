Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZBCFnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZBCFnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZBCFnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:43:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZBCFnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:43:10 -0500
Date: Mon, 2 Feb 2009 23:46:33 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jmorris@namei.org,
       dave@linux.vnet.ibm.com, matthltc@us.ibm.com, zohar@linux.vnet.ibm.com,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/2] TPM: integrity interface
Message-ID: <20090203054633.GA20589@hallyn.com>
References: <cover.1233592745.git.srajiv@linux.vnet.ibm.com> <324e291aaf0c34062f2bca31da95a9f172ae2c28.1233592746.git.srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <324e291aaf0c34062f2bca31da95a9f172ae2c28.1233592746.git.srajiv@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> This patch adds internal kernel support for:
>  - reading/extending a pcr value
>  - looking up the tpm_chip for a given chip number
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

This looks pretty nice, and though it's been awhile since
I've looked at this, the locking looks good too.

Acked-by: Serge Hallyn <serue@us.ibm.com>
