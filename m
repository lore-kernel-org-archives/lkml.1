Return-Path: <linux-kernel-owner+w=401wt.eu-S932735Ab0AFUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0AFUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932722Ab0AFUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab0AFUJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:09:52 -0500
Date: Wed, 6 Jan 2010 21:09:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: caiqian@redhat.com
Cc: Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
	results on s390x)
Message-ID: <20100106200944.GA26204@redhat.com>
References: <1158952983.251101262791902387.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <1126133396.251251262791990053.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1126133396.251251262791990053.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, caiqian@redhat.com wrote:
>
> > Cai, any chance you can help? Using /usr/bin/console I can't choose
> > anotherkernel at the "00: Please choose (default will boot in 15 seconds):"
> > stage, how can I do this???
>
> As Heiko mentioned, I did manage to enter,
>
> #cp vi vmsg 2

if only I new about this magic ;)

Thanks Cai and Heiko!

Oleg.

