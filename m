Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0CJJHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:07:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0CJJG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:06:57 -0500
Message-ID: <4B9761FF.70808@redhat.com>
Date: Wed, 10 Mar 2010 17:10:23 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?= <andre.goddard@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: plug a memory leak situation on dump_seek()
References: <fe97698815cd081b5ab33a8c25c8b69cd0371a99.1267785456.git.andre.goddard@gmail.com>
In-Reply-To: <fe97698815cd081b5ab33a8c25c8b69cd0371a99.1267785456.git.andre.goddard@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

André Goddard Rosa wrote:
> After having started writing the coredump, if filesystem reports an error
> anytime while writing part of the core file, we would leak a memory page
> when bailing out.
> 
> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Looks good for me too!

Thanks.
