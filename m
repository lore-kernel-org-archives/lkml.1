Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXD0P4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXD0P4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbXD0P4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:56:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbXD0P4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:56:10 -0400
Message-ID: <46321D0B.90809@zytor.com>
Date: Fri, 27 Apr 2007 08:55:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com> <20070427010914.GA2570@localhost.localdomain> <46314E0B.1020800@zytor.com> <20070427023252.GA3797@localhost.localdomain> <m1647ijvk1.fsf@ebiederm.dsl.xmission.com> <4631873B.1000107@zytor.com> <m1tzv2ie4i.fsf@ebiederm.dsl.xmission.com> <463189D3.3070805@zytor.com> <20070427102835.GA11449@localhost.localdomain>
In-Reply-To: <20070427102835.GA11449@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> On Thu, Apr 26, 2007 at 10:27:47PM -0700, H. Peter Anvin wrote:
> 
> Thanks! I will take a look at that file.
> 
> Maybe we can rewrite them in C, use a 16-bit C compiler to generate AT&T asm code and finally push the asm code in the kernel source tree. But perhaps there is no such ideal compiler. ;)
> 

No, that would be bad.

	-hpa
