Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXIRRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXIRRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759251AbXIRRKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:10:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45722 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648AbXIRRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:10:10 -0400
Message-ID: <46F0064E.4070507@zytor.com>
Date: Tue, 18 Sep 2007 10:09:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anton Arapov <aarapov@redhat.com>
CC: linux-kernel@vger.kernel.org, James Pearson <james-p@moving-picture.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <E1ITKMm-0002eD-S1@moving-picture.com> <h8k5qoqd45.fsf@pepelac.englab.brq.redhat.com>
In-Reply-To: <h8k5qoqd45.fsf@pepelac.englab.brq.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Arapov wrote:
>   Hi fellas! What we can do for this patch? It looks like ignored at
>   all? I want reinitiate this thread because I want to have the
>   answer!
> 
>   What do you think?

Clean up the style, then we can put it into -mm.

It should be in -mm for about a full kernel cycle.

	-hpa
