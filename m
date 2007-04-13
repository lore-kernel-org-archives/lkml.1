Return-Path: <linux-kernel-owner+w=401wt.eu-S1030319AbXDMVMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030319AbXDMVMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030320AbXDMVMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:12:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319AbXDMVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:12:46 -0400
Message-ID: <461FF245.9040905@zytor.com>
Date: Fri, 13 Apr 2007 14:12:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org> <461FE8EC.3090304@zytor.com> <461FE9D1.1000803@goop.org> <461FEB46.3000702@zytor.com> <461FF09D.4020902@goop.org>
In-Reply-To: <461FF09D.4020902@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Even with PSE?
> 
> Perhaps not.
> 
>> However, the main reason I wanted it done that way is to avoid cargo
>> cult programming; this makes it much clearer where the numbers
>> actually come from.
> 
> Well, how about this then?

I like.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
