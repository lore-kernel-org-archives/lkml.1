Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYIKXfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYIKXfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYIKXfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:35:09 -0400
Received: from services110.cs.uwaterloo.ca ([129.97.152.166]:50169 "EHLO
	services110.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbYIKXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:35:08 -0400
Message-ID: <48C9AB16.3060706@users.sourceforge.net>
Date: Thu, 11 Sep 2008 19:34:46 -0400
From: Elad Lahav <elad_lahav@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Initial support for Niagara T1 performance counters
References: <48C98820.3080009@users.sourceforge.net> <20080911.145937.178601244.davem@davemloft.net>
In-Reply-To: <20080911.145937.178601244.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-w02 with ID 48C9AB28.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 05f0b4ac-fda3-425f-b8c1-3bf571a2c3f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Full support for both T1 and T2 performance counters (as well as those
> of all other sparc64 processors) is contained in the perfmon2 tree.
Fair enough, I wasn't aware that perfmon supported the T1.
Just for the record, is the implementation correct? Specifically, is 
this the right way to extract the PIL at the time of the trap?

Thanks,
Elad
