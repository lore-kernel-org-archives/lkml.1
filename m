Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYKXLHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYKXLHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKXLGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:06:34 -0500
Received: from ns2.suse.de ([195.135.220.15]:39602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYKXLGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:06:31 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
Date: Mon, 24 Nov 2008 16:37:43 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
       mhiramat@redhat.com, contact@ksplice.com, jbarnold@ksplice.com,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com
References: <200811211720.26394.knikanth@suse.de> <20081121133800.GA5244@in.ibm.com> <4926DC1B.1020809@linux.vnet.ibm.com>
In-Reply-To: <4926DC1B.1020809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811241637.44185.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008 21:34:43 Balbir Singh wrote:
> Ananth N Mavinakayanahalli wrote:
> > On Fri, Nov 21, 2008 at 05:20:25PM +0530, Nikanth Karthikesan wrote:
>
> I had a patch for x86 a long time ago in 2005, but I never posted it :(
>

I just didn't wanted to say that after some time. ;)

>
> Yes and we need to be careful about licensing, tainting the kernel with
> such an implementation.
>

Agreed.

> > Kprobes themselves provide enough ammunition to users to shoot themselves
> > in the foot, but this is way more dangerous than that.
> > ...
>
> Undoubtedly, but a good warning is the best way to keep people warned about
> running such code :) It is a useful thing to have and to run, but running
> it would take more guts than anything else.

Thanks for the comments.

Thanks
Nikanth Karthikesan


