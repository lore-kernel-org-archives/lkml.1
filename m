Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXEYTqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXEYTqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765332AbXEYTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:45:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765321AbXEYTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:45:53 -0400
Message-ID: <46573CE4.8080300@zytor.com>
Date: Fri, 25 May 2007 12:45:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: Andi Kleen <andi@firstfloor.org>, Ben Collins <bcollins@ubuntu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from	compressed
 boot wrapper
References: <98cd38b5.git.bcollins@ubuntu.com>	 <b31c080.git.bcollins@ubuntu.com>  <p737iqxcf43.fsf@bingen.suse.de> <1180097543.12570.396.camel@cunning>
In-Reply-To: <1180097543.12570.396.camel@cunning>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins wrote:
> On Fri, 2007-05-25 at 13:33 +0200, Andi Kleen wrote:
>> Ben Collins <bcollins@ubuntu.com> writes:
>>
>> Why? 
> 
> Because there's no other way to make the kernel totally quiet. We've
> been patching this out so that the boot sequence has that "clean look".
> 
> Other than that, it's useless :)
> 

Worse than that, it's harmful.

"Clean look" means "undebuggable."

	-hpa
