Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYCQTjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYCQTjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYCQTjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:39:07 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:12304 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYCQTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:39:05 -0400
Message-ID: <fa686aa40803171239h46878550r1b58d796d0ff8af6@mail.gmail.com>
Date: Mon, 17 Mar 2008 13:39:01 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: powerpc: cuImage.* creation error
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       "Paul Mackerras" <paulus@samba.org>,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080317193652.GA9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317193652.GA9550@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 6c48a27dd9e36bf7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:36 PM, Adrian Bunk <bunk@kernel.org> wrote:
> When building all powerpc defconfigs in 2.6.25-rc6 exactly three of
>  them fail to build, and all with similar problems:
>
>  powerpc64-linux-ld: arch/powerpc/boot/cuboot-tqm8540.o: No such file: No such file or directory
>  make[2]: *** No rule to make target `arch/powerpc/boot/cuImage.tqm8548', needed >  powerpc64-linux-ld: arch/powerpc/boot/cuboot-tqm8540.o: No such file: No such file or directory
>  make[2]: *** [arch/powerpc/boot/cuImage.tqm8540] Error 1
>
>  Is this a problem on my side or is there a bug that should be fixed?

I may have messed something up.  I'll dig into it this afternoon.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
