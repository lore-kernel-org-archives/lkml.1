Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbZBFQe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbZBFQe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZBFQdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:33:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57720 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZBFQdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:33:53 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: integrity: audit
Date: Fri, 6 Feb 2009 11:33:12 -0500
User-Agent: KMail/1.9.10
Cc: Linux Audit <linux-audit@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
References: <1233924230.3135.5.camel@localhost.localdomain> <200902061001.06040.sgrubb@redhat.com> <1233936914.3135.19.camel@localhost.localdomain>
In-Reply-To: <1233936914.3135.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061133.13358.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 11:15:14 am Mimi Zohar wrote:
> The integrity auditing discussions took place a while ago in August 2007
> (http://osdir.com/ml/linux.redhat.security.audit/2007-09/msg00007.html).

Thanks for the refresh. Its been so long, I forgot about this. :)  Re-reading 
the thread, we never had closure on the audit event format.


> The integrity patches are in security-testing-2.6/#next and the auditd
> patch I just posted to linux-audit. How do you suggest we go forward?

We need to go over the event format and make sure its got everything we need 
in it. We also need to review the code that touches the audit system and make 
sure its using the audit API the way we intended. I'd like to do this on the 
linux-audit mail list so there is a record of it in the audit archives.

Thanks,
-Steve
