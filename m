Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXKMSoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXKMSoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760523AbXKMSnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:43:15 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:39944 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbXKMSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:43:14 -0500
X-Greylist: delayed 2512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 13:43:13 EST
Date: Tue, 13 Nov 2007 10:00:25 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
Message-ID: <20071113180025.GA10344@localdomain>
References: <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com> <1194633888761-git-send-email-gco!sta@redhat.com> <11946338932611-git-send-email-gcosta@redhat.com> <1194633898545-git-send-email-gcosta@redhat.com> <11946339033567-git-send-email-gcosta@redhat.com> <11946339082711-git-send-email-gcosta@redhat.com> <11946339142999-git-send-email-gcosta@redhat.com> <20071111180709.GG22277@bingen.suse.de> <47398C4A.40806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47398C4A.40806@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:36:42AM -0200, Glauber de Oliveira Costa wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>
>> And the "EM64T based comment" is wrong because there are AMD based 
>> vSMPs too.
>Just got it as-is from the old Kconfig. Do you think it should be fixed
>as well?

Yep.

Thanks,
Kiran
