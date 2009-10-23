Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbZJWWQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbZJWWQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZJWWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:16:31 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40320 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZJWWQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qkKj6kSsb7mA+rhVaof1YKu1hAC88PTEJynDU8i1NjCZAqELSzg2YXiP3QAx2N9vRp
         4ZVuLbtGhTYKbt3pRz49XFfZEuKxxrnWe6HVh3yIe3WGs1L349rYGXaJz3x6/UQ6v7Bz
         gqRJqlmYlmq3Z99ysLDjZTJ8VgToqQwrkdk4Y=
MIME-Version: 1.0
In-Reply-To: <54b33ccd0910231459j5cb355c4n13859c527e1645ba@mail.gmail.com>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu> <193b0f820910231456o24bf95b6mf3e72f1b27870af5@mail.gmail.com> 
	<54b33ccd0910231459j5cb355c4n13859c527e1645ba@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 23 Oct 2009 20:16:14 -0200
Message-ID: <193b0f820910231516m56361e82v336c9df4ccb13816@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Marti Raudsepp <marti@juffo.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 19:59, Marti Raudsepp <marti@juffo.org> wrote:
> On Sat, Oct 24, 2009 at 12:56 AM, Lucas De Marchi
> <lucas.de.marchi@gmail.com> wrote:
>> I think it's Arch's fault to continue using an unmaintained library
>> when there's an easy replacement, but if the "fix" is easy, why not?
>
> As far as I can tell, libelf is still maintained; the latest release
> is from July 2009.
>

humn... I was looking at FSF site
(http://directory.fsf.org/project/libelf/) where version was not
updated anymore.


Lucas De Marchi
