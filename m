Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXFGPda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXFGPda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbXFGPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:33:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47702 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974AbXFGPdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:33:14 -0400
Message-ID: <46682537.8030303@austin.ibm.com>
Date: Thu, 07 Jun 2007 10:33:11 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: should be executable
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>	 <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>	 <4667F00A.106@shadowen.org> <9a8748490706070452l4e4965b0r2ff6999bac10e237@mail.gmail.com> <46682158.6060709@shadowen.org>
In-Reply-To: <46682158.6060709@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> scripts/checkpatch.pl should be executable, make it so.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> old mode 100644
> new mode 100755
> 

Acked-by: Joel Schopp <jschopp@austin.ibm.com>
