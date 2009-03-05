Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZCEXla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZCEXla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZCEXlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:41:20 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:34614 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZCEXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:41:19 -0500
Message-ID: <49B06327.5020307@oracle.com>
Date: Thu, 05 Mar 2009 15:41:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>	 <1236294142.5937.88.camel@desktop>  <49B05ACF.2010708@oracle.com>	 <1236294733.5937.92.camel@desktop>  <49B05DFC.1090807@oracle.com> <1236295961.5937.99.camel@desktop>
In-Reply-To: <1236295961.5937.99.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49B062C7.0265:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2009-03-05 at 15:19 -0800, Randy Dunlap wrote:
> 
>> Do we have a document style guide?  The comments in Documentation/CodingStyle
>> apply to documentation text files also, AFAIK.  Maybe that needs to be
>> stated explicitly.
> 
> I guess you could assume it applies, but I don't think it's content can
> really be applied to Documents.. Since it speaks specifically to code.

OK.  Historically we have applied the 80-column rule to text files,
including documentation.  But we haven't documented that.

>> As for other docs that don't conform:  we typically don't go around just
>> fixing 80-column rule infractions, but when a file is being modified anyway,
>> we prefer that other parts of it also be updated.
> 
> I don't have a problem fixing it, but it would be nice to have any other
> rules layed out. Like the "No ascii art rule" (if it exists) or whatever
> other style guidelines there are. For example the 80 line limit can't
> apply to absolutely everything. I mean what about diagrams or /proc
> output samples? Most of that is over 80 (way over).

If you have time to make a proposal for all such rules, please go ahead.
I don't have time for it just now.

Yes, some examples, diagrams, samples, etc. are over 80 columns.
It's not a diehard rule.

And there is no rule against ASCII art AFAIK.

-- 
~Randy
