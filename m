Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYIINf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYIINf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIINft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:35:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47092 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIINfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:35:48 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080905153134.GA18367@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu> <20080905153134.GA18367@us.ibm.com>
Message-Id: <E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 09 Sep 2008 15:34:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Serge E. Hallyn wrote:
> Ok I should take the time to properly add these to ltp, but for now here
> is the result of 15-minutes of playing around with shell scripts to do
> some basic testing.
> 
> Run usermounts_root.sh as root first, then usermounts_user as a user.
> Cleanup for the usermounts_root.sh side-effects is not done.
> 
> Miklos, do you have better-thought-out or more complete testcases?

Thanks for the scripts, I don't have any better ones, I have only been
testing by hand.

As for -mm, sure it would be nice.  I'll do a resubmission of the
whole series with proper changelog, etc.  It would be really nice if
Al and/or Christoph could review if there are any major conceptual
problems left.

Thanks,
Miklos
