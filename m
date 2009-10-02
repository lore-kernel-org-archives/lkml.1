Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZJBT5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZJBT5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZJBT5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:57:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbZJBT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:57:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fsrdPmx1VmZ+mHfxVZAdoc0yOBgOy+oizw9DK7R1yqPNAVtbClqwT+xUmLTajs5S7
	zJu7ePXntvw7Jjlygthug==
Date: Fri, 2 Oct 2009 12:57:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       onbons@linux-vserver.oorg, Ed Cashin <ecashin@coraid.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #13942] Troubles with AoE and uninitialized object
In-Reply-To: <COE24pZSBH.A.t9C.XOTxKB@chimera>
Message-ID: <alpine.DEB.1.00.0910021256170.14641@chino.kir.corp.google.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.t9C.XOTxKB@chimera>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-1395773377-1254513426=:14641"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-1395773377-1254513426=:14641
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 1 Oct 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> Subject		: Troubles with AoE and uninitialized object
> Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> Date		: 2009-08-04 10:12 (59 days old)
> References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4
> 

This should be fixed with 18d8217 in Linus' tree.
--531381004-1395773377-1254513426=:14641--
