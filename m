Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIZMiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIZMiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZIZMiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:38:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:37484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZIZMiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:38:11 -0400
Subject: Re: how best to report results of my kernel tree scanning scripts?
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0909260811470.19017@localhost>
References: <alpine.LFD.2.00.0909260811470.19017@localhost>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 18:07:55 +0530
Message-Id: <1253968675.4568.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Sat, 2009-09-26 at 08:16 -0400, Robert P. J. Day wrote:
> since the merge window appears to be ready to close fairly soon(?),
> i'm prepping to run my scanning scripts once again to identify (among
> other things):
> 
>   * unused Kconfig CONFIG variables
>   * references to CONFIG_ variables that don't even exist (both in
>     source files and Makefiles)
>   * references to non-existent header files
> 
> and bunches of other things.  i'm open as to the best way to post the
> results, since different people have different opinions.
> 
>   and, no, i can't just submit patches since, in many cases, i have no
> idea what the fix should be (if any) -- that's the kind of decision
> best left to the respective subsystem maintainers.
> 
>   thoughts?  this is where i put the old output:
> 
> http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup
> 

Thanks for reporting these results, I will try to fix them and submit
patches with Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>

Thanks,
--
JSR

