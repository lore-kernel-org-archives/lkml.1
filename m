Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYA2XZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYA2XZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYA2XZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:25:37 -0500
Received: from main.gmane.org ([80.91.229.2]:33859 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbYA2XZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:25:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Date: Tue, 29 Jan 2008 23:25:22 +0000
Message-ID: <yw1x8x2843kt.fsf@mansr.com>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:JcO7c8f3QrYZRL2OHcVcXp2VKQ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
>> Hello!
>> 
>> It have come to my attention that a patch has been committed to the
>> kernel with the explicit purpose of tainting ndiswrapper - the kernel
>> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
>> be used by the kernel.
>>...
>> Just to reiterate some points from the old discussion:
>>...
>> - no copyright violation is involved, as Windows drivers are not derived
>> from Linux sources
>>...
>
> It is interesting that someone posting with an @gnu.org address claims
> that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> not a copyright violation.

As long as you don't distribute /proc/kcore, I can't see how the GPL
would have any say in the matter.  The Windows drivers are (unrelated
violations aside) clearly not derived from GPL code.

IANAL

-- 
Måns Rullgård
mans@mansr.com

