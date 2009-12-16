Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbZLPPLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbZLPPLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762214AbZLPPLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:11:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38594 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762208AbZLPPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:11:07 -0500
Date: Wed, 16 Dec 2009 15:10:58 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 9a884ab64a4d092b4c3bf24fd9a30f7fbd4591e7 causes
	boot hang
Message-ID: <20091216151058.GB15217@srcf.ucam.org>
References: <20091215181538.GA28707@srcf.ucam.org> <1260925040.3834.69.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260925040.3834.69.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:57:20AM +0800, Lin Ming wrote:

> Could you try the attached ACPICA latest release (20091214) patch
> series? There are module level code and _REG method fixes included in
> it.

Yes, that appears to fix it. Len, could you push these ASAP?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
