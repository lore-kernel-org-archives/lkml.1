Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZCLVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZCLVC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZCLVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:02:48 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59609 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZCLVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:02:47 -0400
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
From: Greg Kurz <gkurz@fr.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Cedric Le Goater <legoater@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, xemul@openvz.org
In-Reply-To: <20090312145311.GC12390@us.ibm.com>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <1234479845.30155.220.camel@nimitz>
	 <20090226155755.GA1456@x200.localdomain>
	 <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr>
	 <20090312145311.GC12390@us.ibm.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 22:01:59 +0100
Message-Id: <1236891719.32630.14.camel@bahia>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 09:53 -0500, Serge E. Hallyn wrote:
> Or are you suggesting that you'll do a dummy clone of (5594,2) so that
> the next clone(CLONE_NEWPID) will be expected to be (5594,3,1)?
> 

Of course not but one should be able to tell clone() to pick a specific
pid.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

