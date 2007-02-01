Return-Path: <linux-kernel-owner+w=401wt.eu-S1422989AbXBAUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422989AbXBAUaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422993AbXBAUaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:30:14 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:31994 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422989AbXBAUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:30:12 -0500
Message-ID: <45C24DC1.3050801@fr.ibm.com>
Date: Thu, 01 Feb 2007 21:29:53 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       keith mannthey <kmannth@us.ibm.com>
Subject: Re: 2.6.20-rc6-mm3
References: <B41635854730A14CA71C92B36EC22AAC7CC65D@mssmsx411>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC7CC65D@mssmsx411>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Starikovskiy, Alexey Y wrote:
> Sorry, here is the patch... ACPI has switched to acpi_find_rsdp(), so
> srat.c might want to do that too, please check.

got it. running a compile and boot test. 

I should have the results in 'my' morning (UTC+1).

Thanks !

C.
