Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZBFQPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZBFQPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZBFQP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:15:29 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44366 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZBFQP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:15:28 -0500
Subject: Re: integrity: audit
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Linux Audit <linux-audit@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
In-Reply-To: <200902061001.06040.sgrubb@redhat.com>
References: <1233924230.3135.5.camel@localhost.localdomain>
	 <200902061001.06040.sgrubb@redhat.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 11:15:14 -0500
Message-Id: <1233936914.3135.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 10:01 -0500, Steve Grubb wrote:
> On Friday 06 February 2009 07:43:50 am Mimi Zohar wrote:
> > This patch adds support to auditd for integrity messages, which are
> > issued as a result of the integrity patchset that was applied to the
> > security-testing-2.6/#next tree.
> >
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> NACK to anything around this. So far, no integrity patches have been reviewed 
> by the audit folks.
> 
> -Steve

The integrity auditing discussions took place a while ago in August 2007
(http://osdir.com/ml/linux.redhat.security.audit/2007-09/msg00007.html).
The integrity patches are in security-testing-2.6/#next and the auditd
patch I just posted to linux-audit. How do you suggest we go forward?

Thanks!

Mimi

