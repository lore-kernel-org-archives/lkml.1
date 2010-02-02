Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0BBVry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:47:54 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:46465 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab0BBVrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kFUvz/1tfff6nIT+34QLrdFrJGUAASOV62EpgCzpomRVtCa+c41yHommpdbc1FNDjc
         xZ/CWaRYDqtNNnLDm5+uzXxBnmXGFAN37PH0KMjzjLOUYBBnK8iV5pRSfVeVg0JdgRih
         vYIekemFAmyWPvVqEtV1C0+4h1OPM/SFxGayU=
MIME-Version: 1.0
In-Reply-To: <20100202194208.GD5733@kernel.dk>
References: <201002020255.46920.edward.shishkin@gmail.com>
	 <20100202081728.GA2384@infradead.org> <4B6843E9.9070600@gmail.com>
	 <20100202194208.GD5733@kernel.dk>
Date: Wed, 3 Feb 2010 01:47:50 +0400
Message-ID: <5e2ec5ac1002021347k3a8cd8adta5ff76efe1eeaadb@mail.gmail.com>
Subject: Re: [patch 0/7] per-bdi flushing model improvements. reiser4
From: Ronni Holm-Nielsen <theronni@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 11:42 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Tue, Feb 02 2010, Edward Shishkin wrote:
> > Christoph Hellwig wrote:
> >> I got this introduction twice, but patches 1-3 didn't make it to any of
> >> the lists.
> Where?

To clarify (being a ReiserFS subscriber):
patch 0, 4-6 sent to Andrew, ReiserFS, linux-fsdevel, linux-kernel,
xfs, jens.axboe
patch 1-3, 7 sent to Andrew, ReiserFS

- Ronni
