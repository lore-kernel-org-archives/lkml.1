Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXL1Mwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXL1Mwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 07:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbXL1Mwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 07:52:39 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59534 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXL1Mwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 07:52:39 -0500
Date: Fri, 28 Dec 2007 18:15:32 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: vgoyal@redhat.com, hbabu@us.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: kexec refuses to boot latest -mm
Message-ID: <20071228124532.GB32643@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
kexec. It just gets stuck at "Starting new kernel".

It does boot normally when booted as the first kernel.

Any hints debugging? (x86 architecture)

-- 
regards,
Dhaval
