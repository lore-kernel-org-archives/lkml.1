Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXBESPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXBESPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbXBESPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:15:21 -0500
Received: from rtr.ca ([64.26.128.89]:4590 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbXBESPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:15:19 -0500
Message-ID: <45C77435.8090806@rtr.ca>
Date: Mon, 05 Feb 2007 13:15:17 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca>
In-Reply-To: <45C4DF2A.1070501@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>..
> Only some of the hdparm functionality is supported in libata,

That's not true.  MOST hdparm functionality is supported in libata.
Only a very few things are not supported, including -d and -X,
for reasons already pointed out.

Nearly everything else works.

-ml
