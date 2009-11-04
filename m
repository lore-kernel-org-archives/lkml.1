Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbZKDTMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbZKDTMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbZKDTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbZKDTMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:12:43 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC] Block IO Controller V1
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 14:12:19 -0500
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:37 -0500")
Message-ID: <x49ws26rtnw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi All,
>
> This is V1 of the Block IO controller patches on top of 2.6.32-rc5.
>
> A consolidated patch can be found here:
>
> http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v1.patch

Overall it looks good.  Vivek, could you please run some benchmarks
against a vanilla kernel and then with your patch applied and cgroups
compiled in but not configured?

Cheers,
Jeff
