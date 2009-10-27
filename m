Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZJ0Bhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZJ0Bhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZJ0Bhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:37:54 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:49992 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZJ0Bhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:37:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=IrQ8ctM8mxE2CTjuHxCW6VzoUwBv1Lmpe8ACxZ13l21gvmf/5uxxckyhn7R7PMZeKM
         LfYQeAxuVXf4xiyzOm+ExyKoDce+wZqRf9Ee6+V4a0jIlDJj6wF9LWzpqa0JhXqu2fgT
         6itd3qdkmdBmvSULZR00d0Gbpgu1CVKv8ZHP8=
Subject: Re: What ever happened to: [PATCH] MIPS: add support for
 gzip/bzip2/lzma compressed kernel images
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, ralf@linux-mips.org,
       alex@digriz.org.uk, ithamar.adema@team-embedded.nl,
       linux-mips <linux-mips@linux-mips.org>
In-Reply-To: <1256606966.26028.364.camel@gandalf.stny.rr.com>
References: <1256606966.26028.364.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 27 Oct 2009 09:37:48 +0800
Message-Id: <1256607468.5499.7.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 2009-10-26 at 21:29 -0400, Steven Rostedt wrote:
> Hi,
> 
> I'm playing with ftrace on MIPS thanks to Lemote for supplying me a
> machine. And I noticed that, although Wu's repo gives me a nice vmlinuz
> to install, the default kernels do not.
> 
> Wu wrote a nice patch that adds this feature, and I see that he posted
> it a few months back:
> 
> http://www.linux-mips.org/archives/linux-mips/2009-08/msg00056.html
> 
> I do not see it in the mainline nor in Ralf's repo on kernel.org. I'm
> hoping that it did not get lost and forgotten. What ever happened to it?

Ralf have added this to his -queue git repo:

http://www.linux-mips.org/git?p=linux-queue.git;a=commit;h=9d20b1ddf20c3ead5e381a1d06471c33d7f3cb6d

Thanks :-)
	Wu Zhangjin

