Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZI2GSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZI2GSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZI2GSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:18:22 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53568 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZI2GSW (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Tue, 29 Sep 2009 02:18:22 -0400
Message-ID: <4AC1A6FB.1080304@suse.de>
Date: Tue, 29 Sep 2009 11:49:39 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mm-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, Sep 10, 2009 at 11:31 AM,  <akpm@linux-foundation.org> wrote:
> The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
>
>   http://userweb.kernel.org/~akpm/mmotm/
>
> and will soon be available at
>
>   git://git.zen-sources.org/zen/mmotm.git
>

With this snapshot plus fixes, I'm unable to limit the memory using the
kernel command line switch "mem=nn" on a x86_64 box. Is this the
expected behavior?

Using "cgroup_disable=memory" together with "mem=nn" switch didn't help.
Am I supposed to use some other switch along with this?

Thanks,

-- 
Suresh Jayaraman
