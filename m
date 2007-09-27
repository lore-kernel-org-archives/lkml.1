Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXI0URz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXI0URz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXI0URr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:17:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:53810 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbXI0URq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:17:46 -0400
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: New 'Changes-licensed-under' tag introduced for Linux-wireless
References: <43e72e890709271100n39f16c18x723dc7a85d418666@mail.gmail.com>
	<20070927110950.0561eca1@freepuppy.rosehill>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 27 Sep 2007 22:17:43 +0200
In-Reply-To: <20070927110950.0561eca1@freepuppy.rosehill> (Stephen Hemminger's message of "Thu, 27 Sep 2007 11:09:50 -0700")
Message-ID: <m34phfsw0o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> writes:

> No, please don't down this legal rat hole. It would cause bullshit like
> people submitting dual licensed patches to the scheduler or GPL only
> patches to the ath5k or ACPI code.

Precisely. Signed-off-by means the patch author already authorized
the patch to be applied. With the patch merged the conditions still
in the file (project etc) apply and not some obscure email tags.

If someone really wants to change licencing conditions then the
licence conditions in the source code must be changed.

> Instead, add a section to Documentation/SubmittingPatches that clearly
> states that all changes to a file are licensed under the same license
> as the original file. I don't feel legally qualified to write the correct
> wording.

Current Documentation/SubmittingPatches:
        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            indicated in the file; or
            ^^^^^^^^^^^^^^^^^^^^^
-- 
Krzysztof Halasa
