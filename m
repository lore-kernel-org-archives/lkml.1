Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXJXBQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXJXBQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXJXBP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:15:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbXJXBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:15:57 -0400
Message-ID: <471E9CC1.90102@zytor.com>
Date: Tue, 23 Oct 2007 18:15:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 0/3] x86 boot: 32-bit boot protocol
References: <1193126765.23935.74.camel@caritas-dev.intel.com>	 <471E7078.4050908@zytor.com> <1193187847.23935.95.camel@caritas-dev.intel.com>
In-Reply-To: <1193187847.23935.95.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> Do you think it is possible that the 3rd patch of the patchset: document
> for 32 bit boot protocol can be merged into upstream firstly? It has
> been used by kexec/LinuxBIOS already and the EFI support patches depend
> on it too.
> 

Well, the part of it that doesn't document the 2.08 boot protocol, at 
least, since it documents existing practice.

	-hpa
