Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZKBQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZKBQrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZKBQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:47:21 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40401 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZKBQrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:47:20 -0500
Message-ID: <4AEF0D0B.1000100@austin.ibm.com>
Date: Mon, 02 Nov 2009 10:47:07 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v5] Kernel DLPAR Infrastructure
References: <4AE8ADCF.6090104@austin.ibm.com> <4AE8AF4D.4030403@austin.ibm.com> 	<1256785731.26770.38.camel@pasglop> <4AEF086D.9010600@austin.ibm.com> <fa686aa40911020840s3a6a4819g85f3be3a305820bf@mail.gmail.com>
In-Reply-To: <fa686aa40911020840s3a6a4819g85f3be3a305820bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Mon, Nov 2, 2009 at 9:27 AM, Nathan Fontenot <nfont@austin.ibm.com> wrote:
>> I saw that Grant Likely is doing updates to all of the of_* stuff right now,
>> would it be ok to have these routines here, renamed as dlpar_*, and look
>> to merge them in with Grant's updates when he finishes?
> 
> No because then we're stuck with renaming the API at a later date.
> Name it what it is, and put it where it belongs.  I'll deal with any
> merge breakage as it occurs.
> 

ok.  Would this be better off in powerpc code, or should I go ahead and put it
in something like drivers/of/dynamic.c?

-Nathan Fontenot
