Return-Path: <linux-kernel-owner+w=401wt.eu-S1765237AbXEYToQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765237AbXEYToQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXEYToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:44:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbXEYToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:44:06 -0400
Message-ID: <46573C70.2070209@zytor.com>
Date: Fri, 25 May 2007 12:43:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Auke Kok <auke-jan.h.kok@intel.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [CodingStyle] Add comment to not put spaces before
 tabs.
References: <20070525172509.5138.56430.stgit@localhost.localdomain> <46571DA8.1000402@s5r6.in-berlin.de>
In-Reply-To: <46571DA8.1000402@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Auke Kok wrote:
>> +Don't put spaces before tabs or mix them.
> 
> Make it "Don't put spaces before tabs."
> 
> We do mix them if we combine tabs for indentation with spaces for alignment.

It would probably be good to add a pointer to the cleanfile/cleanpatch
scripts here, too.

	-hpa
