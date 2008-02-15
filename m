Return-Path: <linux-kernel-owner+w=401wt.eu-S1764896AbYBOGKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764896AbYBOGKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761359AbYBOGKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:10:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:33802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761047AbYBOGKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:10:09 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Thomas, Sujith" <sujith.thomas@intel.com>
Subject: Re: [patch 1/6] Generic thermal management: validate input parameters
Date: Fri, 15 Feb 2008 01:09:36 -0500
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Zhang, Rui" <rui.zhang@intel.com>
References: <05B550FD4BD2014E841D83547B62600802AA64FF@bgsmsx411.gar.corp.intel.com>
In-Reply-To: <05B550FD4BD2014E841D83547B62600802AA64FF@bgsmsx411.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802150109.36632.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008 00:22, Thomas, Sujith wrote:
> From: Thomas Sujith <sujith.thomas@intel.com>

Thanks Sujith, this patch series was a massive improvement over the last one --
checkpatch.pl clean and everything:-)

I think if you can get rid of the outlook-destroys-plain text via word-wrap
so you don't need to also attach the patches, then you're cookin' with gas.

In the mean time, I've loaded the attachments into the acpi test tree.
if you send more attachments in the future, please start them
with the 1st line as a Subject: so they look to the tools like e-mail.

eg.

Subject: intel_menlo: extract return values using PTR_ERR
From: Thomas Sujith <sujith.thomas@intel.com>

Need to extract errors using PTR_ERR macro and...


thanks,
-Len
