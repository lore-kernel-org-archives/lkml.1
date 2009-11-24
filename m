Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZKXHSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZKXHSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZKXHSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:18:51 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35902 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZKXHSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kwGN4/zyFWVQUGucj6QqpZ/Mh6SE30rUenavRtZRkfsozh2cw1+vhe/+evKScKg7om
         eH+1ghSvYleMe5S//CrtSZxAWoZ9+uVPoe2OoYGKEMMh1rvS1el3dfcVgKh1cm/BPhRv
         TxWexdBwx4BzhdDKD602NmDXfG9jMIMTvQCYc=
MIME-Version: 1.0
In-Reply-To: <4B0B6E44.6090106@cn.fujitsu.com>
References: <4B0B6E44.6090106@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 09:18:56 +0200
X-Google-Sender-Auth: c3e30c3739b5cd51
Message-ID: <84144f020911232318q7ad8028ej13bf7799030878bc@mail.gmail.com>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more 
	statistics
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> List of new things:
>
> - Add option "--raw-ip", to print raw ip instead of symbols.
>
> - Sort the output by fragmentation by default, and support
>  multi keys.
>
> - Collect and show cross node allocation stats.
>
> - Collect and show alloc/free ping-pong stats.
>
> - And help file.

The series looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
