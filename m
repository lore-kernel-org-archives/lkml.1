Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZCEXc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZCEXc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbZCEXco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:32:44 -0500
Received: from fifo99.com ([67.223.236.141]:40748 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbZCEXcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:32:43 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <49B05DFC.1090807@oracle.com>
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org>
	 <1236294142.5937.88.camel@desktop>  <49B05ACF.2010708@oracle.com>
	 <1236294733.5937.92.camel@desktop>  <49B05DFC.1090807@oracle.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 15:32:41 -0800
Message-Id: <1236295961.5937.99.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 15:19 -0800, Randy Dunlap wrote:

> Do we have a document style guide?  The comments in Documentation/CodingStyle
> apply to documentation text files also, AFAIK.  Maybe that needs to be
> stated explicitly.

I guess you could assume it applies, but I don't think it's content can
really be applied to Documents.. Since it speaks specifically to code.

> As for other docs that don't conform:  we typically don't go around just
> fixing 80-column rule infractions, but when a file is being modified anyway,
> we prefer that other parts of it also be updated.

I don't have a problem fixing it, but it would be nice to have any other
rules layed out. Like the "No ascii art rule" (if it exists) or whatever
other style guidelines there are. For example the 80 line limit can't
apply to absolutely everything. I mean what about diagrams or /proc
output samples? Most of that is over 80 (way over).

Daniel

