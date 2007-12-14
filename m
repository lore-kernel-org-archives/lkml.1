Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXLNDBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXLNDBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXLNDBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:01:31 -0500
Received: from ozlabs.org ([203.10.76.45]:45847 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157AbXLNDBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:01:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18273.61952.774601.392188@cargo.ozlabs.ibm.com>
Date: Fri, 14 Dec 2007 14:01:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix implicit declaration in via-pmu.c
In-Reply-To: <20071213215911.GA8591@redhat.com>
References: <20071213215911.GA8591@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones writes:

> drivers/macintosh/via-pmu.c: In function 'register_pmu_pm_ops':
> drivers/macintosh/via-pmu.c:2481: error: implicit declaration of function 'pm_set_ops'

What tree is this against?  I don't see any occurrences of pmu_pm_ops
in either 2.6.23 or Linus' current tree, or in my published
powerpc.git tree.

Paul.
