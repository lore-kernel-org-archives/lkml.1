Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYCMN5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYCMN5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYCMN5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:57:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbYCMN5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:57:35 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: linux-audit@redhat.com
Subject: Re: [RFC][PATCH -v2] Smack: Integrate with Audit
Date: Thu, 13 Mar 2008 09:55:51 -0400
User-Agent: KMail/1.9.9
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080310182634.GA448@ubuntu> <20080312024446.GA5820@ubuntu> <1205326375.23866.215.camel@moss-spartans.epoch.ncsc.mil>
In-Reply-To: <1205326375.23866.215.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130955.53263.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 08:52:55 am Stephen Smalley wrote:
> Only question I have is whether audit folks are ok with reuse of the
> flags in this manner

I am not going to have time to look at this until next week. I don't know how 
much help I can be since I don't actually have a system that would be running 
this new MAC framework. So, the less the audit system changes, the more 
likely it is to be OK. Lots of wild changes I can't see or test is bad.

-Steve
