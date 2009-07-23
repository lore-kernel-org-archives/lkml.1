Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZGWRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZGWRVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZGWRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:21:51 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:57863 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZGWRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:21:51 -0400
Message-ID: <4A689C03.3040508@ans.pl>
Date: Thu, 23 Jul 2009 19:21:07 +0200
From: =?ISO-8859-2?Q?Krzysztof_Ol=EAdzki?= <ole@ans.pl>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc4
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-07-23 04:44, Linus Torvalds wrote:
> Ok, that was a fun week.
> 
> We had a binutils bug, a ccache bug, and a compiler bug. And that was just 
> the bugs that were outside the kernel, but resulted in a broken build.
> 
> But while that was unusual, the rest of the stuff is pretty regular. Lots 
> of small fixes all around. The patch is dominated by a couple of new 
> network drivers, but apart from those, it's generally pretty small - lots 
> of one-liners and "few-liners".
> 
> The shortlog gives a reasonable idea about what's happened. 
> 
> 		Linus
> 
> ---
<CUT>
> Linus Torvalds (3):
>       fbmon: work around compiler bug in gcc-2.4.2

Off by +2.-2.+2 error. ;)

Best regards,

				Krzysztof Olêdzki
