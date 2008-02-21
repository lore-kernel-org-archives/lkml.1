Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbYBUTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbYBUTr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764914AbYBUTrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:47:23 -0500
Received: from gw.goop.org ([64.81.55.164]:59388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891AbYBUTrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:47:22 -0500
Message-ID: <47BDD4BF.3000808@goop.org>
Date: Thu, 21 Feb 2008 11:45:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, dmitry.torokhov@gmail.com,
       virtualization@lists.osdl.org, linux-input@vger.kernel.org,
       adaplas@pol.net, akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: Re: [PATCH 0/2] xen pvfb: Para-virtual framebuffer,	keyboard and
 pointer
References: <871w76ejdg.fsf@pike.pond.sub.org> <87hcg2cyti.fsf@pike.pond.sub.org>
In-Reply-To: <87hcg2cyti.fsf@pike.pond.sub.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Armbruster wrote:
> Forgot to mention: This patch depends on
>
>     Subject: [PATCH] xen: Make xen-blkfront write its protocol ABI to xenstore
>     From: Markus Armbruster <>
>     Date: Thu, 06 Dec 2007 14:45:53 +0100
>
> http://lkml.org/lkml/2007/12/6/132
>
> Sorry!

Sorry, I haven't pushed this upstream yet, since there didn't seem to be 
any particular urgency.  What's the dependency?

    J
