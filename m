Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864Ab0AFPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0AFPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184Ab0AFPdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:33:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab0AFPdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:33:17 -0500
Date: Wed, 6 Jan 2010 10:33:10 -0500 (EST)
From: caiqian@redhat.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, caiqian@redhat.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Message-ID: <1126133396.251251262791990053.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1158952983.251101262791902387.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
 results on s390x)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cai, any chance you can help? Using /usr/bin/console I can't choose
> anotherkernel at the "00: Please choose (default will boot in 15 seconds):"
> stage, how can I do this???

As Heiko mentioned, I did manage to enter,

#cp vi vmsg 2

during the prompt to get to the second kernel to boot...

Thanks,
CAI Qian
