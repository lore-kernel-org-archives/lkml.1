Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbXL0SIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbXL0SIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXL0SId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:08:33 -0500
Received: from slackadelic.com ([65.196.224.53]:44861 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbXL0SIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:08:32 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 0/7] Fix the ACPI 1.0 vs ACPI 2.0 suspend ordering issue
Date: Thu, 27 Dec 2007 18:08:25 +0000
User-Agent: KMail/1.9.7
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl>
In-Reply-To: <200712271903.53961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271808.26995.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2007 18:03:52 Rafael J. Wysocki wrote:
> Please review (and test, if possible).

Suspend now works properly here with this patch set.

Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
