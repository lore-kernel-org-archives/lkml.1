Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYGGOpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYGGOpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGGOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:45:24 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:37560 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYGGOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:45:22 -0400
X-BigFish: VPS-21(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3N4Z8-01-8US-01
Date: Mon, 7 Jul 2008 16:45:11 +0200
From: Robert Richter <robert.richter@amd.com>
To: Richard Purdie <rpurdie@openedhand.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Philippe Elie <phil.el@wanadoo.fr>,
       John Levon <levon@movementarian.org>,
       Maynard Johnson <maynardj@us.ibm.com>,
       Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
       Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH] OProfile kernel maintainership changes
Message-ID: <20080707144511.GE24467@erda.amd.com>
References: <1215197619-28982-1-git-send-email-robert.richter@amd.com> <20080704120942.ed671ce2.akpm@linux-foundation.org> <1215210995.8410.29.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1215210995.8410.29.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Jul 2008 14:45:11.0986 (UTC) FILETIME=[0F55A920:01C8E040]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.07.08 23:36:34, Richard Purdie wrote:
> On Fri, 2008-07-04 at 12:09 -0700, Andrew Morton wrote:

> > Will you also have a role in oprofile userspace maintenance?
> 
> OProfile maintainership is undergoing some transitions as announced by
> John on the oprofile list earlier today. 
> 
> In summary, Maynard is taking over the overall control of oprofile
> userspace with Daniel advising on the JIT stuff and me taking on
> responsibility for the arm kernel+userspace bits and the userspace GUI
> bits. Robert has volunteered to take a role of looking after the kernel
> side of things alongside or replacing Philippe depending on how he feels
> about this - I'm not 100% clear on Philippe's position on things. John
> will still be around to keep an eye on us all :).

Right, I will maintain the kernel part only.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

