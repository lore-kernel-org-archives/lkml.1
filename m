Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXDJHuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXDJHuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXDJHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:50:04 -0400
Received: from mail.suse.de ([195.135.220.2]:48471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXDJHuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:50:02 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ashok Raj <ashok.raj@intel.com>
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization Technology for Directed I/O
Date: Tue, 10 Apr 2007 09:49:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
References: <20070409215552.221374000@intel.com>
In-Reply-To: <20070409215552.221374000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704100949.56130.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007 23:55:52 Ashok Raj wrote:

> Please help review and provide feedback.

High level question: how did you solve the "user X server needs IOMMU bypass"
problem?

-Andi
