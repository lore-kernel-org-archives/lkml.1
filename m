Return-Path: <linux-kernel-owner+w=401wt.eu-S965748AbXCPRJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbXCPRJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXCPRJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:09:42 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:21497
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965748AbXCPRJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:09:42 -0400
Message-Id: <45FADD70.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Fri, 16 Mar 2007 17:09:52 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, "Linus Torvalds" <torvalds@osdl.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work
	with	CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org>
 <45FA16FE.7010805@vmware.com> <45FA26DA.7020109@goop.org>
 <45FA5E7B.76E4.0078.0@novell.com> <45FAC9FB.6070800@goop.org>
In-Reply-To: <45FAC9FB.6070800@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.03.07 17:46 >>>
>Jan Beulich wrote:
>> I have one, too (which is one reasone why I created the original Xen patch).
>>   
>
>It's some version of SuSE 9, right?  What glibc version?

Yes. 2.3.2.

Jan
