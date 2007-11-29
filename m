Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbXK2M5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbXK2M5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbXK2M5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:57:25 -0500
Received: from smtpoutm.mac.com ([17.148.16.81]:51682 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180AbXK2M5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:57:24 -0500
In-Reply-To: <200711290827.04950.a1426z@gawab.com>
References: <20071127235237.GF15227@1wt.eu> <Pine.LNX.4.64.0711281811500.27959@racer.site> <200711282130.12864.a1426z@gawab.com> <200711290827.04950.a1426z@gawab.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6DFD2A04-1D18-4B04-98BA-AE14F6BDB4C7@mac.com>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: git guidance
Date: Thu, 29 Nov 2007 07:57:18 -0500
To: Al Boldi <a1426z@gawab.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007, at 00:27:04, Al Boldi wrote:
> Jakub Narebski wrote:
>> Besides, you can always use "git show <revision>:<file>". For  
>> example gitweb (and I think other web interfaces) can show any  
>> version of a file or a directory, accessing only repository.
>
> Sure, browsing is the easy part, but Version Control starts when  
> things become writable.

But... git history is very inherently completely immutable once  
created... that's the only way you can index everything with a simple  
SHA-1.  If you want to write to the "git filesystem" by adding new  
commits then you need to use the appropriate commands, same as every  
other VCS on the planet.

Cheers,
Kyle Moffett

