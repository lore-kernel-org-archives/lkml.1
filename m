Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYA3BJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYA3BJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYA3BJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:09:45 -0500
Received: from agrajag.mansr.com ([78.86.181.102]:44420 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYA3BJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:09:45 -0500
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 20:09:44 EST
To: Adrian Bunk <bunk@kernel.org>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ndiswrapper and GPL-only symbols redux
References: <1201641765.18773.35.camel@dv>
	<20080129225701.GS8767@does.not.exist> <yw1x8x2843kt.fsf@mansr.com>
	<20080130003519.GB1802@does.not.exist>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Wed, 30 Jan 2008 00:46:06 +0000
In-Reply-To: <20080130003519.GB1802@does.not.exist> (Adrian Bunk's message of "Wed, 30 Jan 2008 02:35:19 +0200")
Message-ID: <yw1x4pcw3zu9.fsf@mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> On Tue, Jan 29, 2008 at 11:25:22PM +0000, Måns Rullgård wrote:
>> Adrian Bunk <bunk@kernel.org> writes:
>> 
>> > On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
>> >> Hello!
>> >> 
>> >> It have come to my attention that a patch has been committed to the
>> >> kernel with the explicit purpose of tainting ndiswrapper - the kernel
>> >> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
>> >> be used by the kernel.
>> >>...
>> >> Just to reiterate some points from the old discussion:
>> >>...
>> >> - no copyright violation is involved, as Windows drivers are not derived
>> >> from Linux sources
>> >>...
>> >
>> > It is interesting that someone posting with an @gnu.org address claims
>> > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
>> > not a copyright violation.
>> 
>> As long as you don't distribute /proc/kcore, I can't see how the GPL
>> would have any say in the matter.  The Windows drivers are (unrelated
>> violations aside) clearly not derived from GPL code.
>
> Someone might sell a laptop with Linux installed?

Not a problem, unless it is booted when sold.  Even that might not be
a problem, since it would be a matter of transferring ownership of a
single copy, not creating and distributing new copies, and the GPL
does is only concerned with the latter.

-- 
Måns Rullgård
mans@mansr.com
