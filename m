Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbZBFPB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbZBFPB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZBFPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:01:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZBFPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:01:46 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: integrity: audit
Date: Fri, 6 Feb 2009 10:01:05 -0500
User-Agent: KMail/1.9.10
Cc: Linux Audit <linux-audit@redhat.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
References: <1233924230.3135.5.camel@localhost.localdomain>
In-Reply-To: <1233924230.3135.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061001.06040.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 07:43:50 am Mimi Zohar wrote:
> This patch adds support to auditd for integrity messages, which are
> issued as a result of the integrity patchset that was applied to the
> security-testing-2.6/#next tree.
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

NACK to anything around this. So far, no integrity patches have been reviewed 
by the audit folks.

-Steve
