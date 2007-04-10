Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXDJIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXDJIeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXDJIeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:34:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXDJIeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:34:17 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Lu, Yinghai" <yinghai.lu@amd.com>
Subject: Re: [PATCH] x86_64/acpi: make kernel to be compiled when CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
Date: Tue, 10 Apr 2007 04:32:42 -0400
User-Agent: KMail/1.9.5
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <86802c440704032055q43691a64v9eefb2a625c095ed@mail.gmail.com> <5986589C150B2F49A46483AC44C7BCA4907513@ssvlexmb2.amd.com> <5986589C150B2F49A46483AC44C7BCA490751D@ssvlexmb2.amd.com>
In-Reply-To: <5986589C150B2F49A46483AC44C7BCA490751D@ssvlexmb2.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704100432.42545.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

grep ACPI .config
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_PNPACPI is not set

This config builds fine.

Let me know if you have one that doesn't.

thanks,
-Len
