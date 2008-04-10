Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYDJGl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYDJGl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYDJGlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:41:21 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:29348 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYDJGlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:41:20 -0400
Message-ID: <c42f92750804092341q7352ae77tc6e353a398724f59@mail.gmail.com>
Date: Thu, 10 Apr 2008 12:11:18 +0530
From: "Shakul Mohideen Hameed" <smohideen@blackhole.labs.rootshell.ws>
To: linux-kernel@vger.kernel.org
Subject: Re: [GIT] git-clone failure over http
In-Reply-To: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c42f92750804092213p7b2c5607sa48a83086d45a825@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see issue while extracting Ingo's scheduler development branch only.

Doing a extract on Linus main branch doesnt arise any issue
got f4be31ec9690cfe6e94fcbed6ae60a6a38b3c3ed
walk f4be31ec9690cfe6e94fcbed6ae60a6a38b3c3ed
got cb2e3ce144808fff867d043c58117f30cdf4c1f9
got 44cad261025c04327fd7e847a7088fd3031b0c3e
walk 44cad261025c04327fd7e847a7088fd3031b0c3e
Getting alternates list for
http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git




On 4/10/08, Shakul Mohideen Hameed
<smohideen@blackhole.labs.rootshell.ws> wrote:
> I am getting errors while cloning few of the kernel sources over HTTP.
> Both proxy/direct modes are failing.
> Please advise.
>    - smohideen
>
>
> git version 1.5.0.6
>
>
> [moin@tb32-tgw1 linux-kernel]$ git-clone
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> Initialized empty Git repository in
> /home/moin/linux-kernel/linux-2.6-sched-devel/.git/
> Getting alternates list for
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Also look at http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> Getting pack list for
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Getting index for pack ef5edbcc679c9e7e54731ae6e8835d1f9337cf60
> Getting pack list for
> http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
> error: Unable to find 7180c4c9e09888db0a188f729c96c6d7bd61fa83 under
> http://www.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git/
> Cannot obtain needed object 7180c4c9e09888db0a188f729c96c6d7bd61fa83
>
