Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0CGLBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:01:43 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57555 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0CGLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XktGeuj+0TUqN8YDkJiM8asbYHaJekC9HjC/2NN0NX/cFfz62Nush6Tn1AuIli/FU0
         9qM8OXYxT7fFY5cdn+WuPgebqMaYmb6IUuUHabkMjeaQZCSg0hRB+iNqY5c3nm2L4Wr+
         BSuBMLJ+i5fyE3XsNy+psQHGzyJKjpNwP9O0M=
MIME-Version: 1.0
In-Reply-To: <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com>
	 <19346.6765.457769.167118@pilspetsen.it.uu.se>
	 <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
	 <20100306104131.GV28972@buzzloop.caiaq.de>
	 <25ae2d691003061705l5fc0bca7n4a07f558a0c410cf@mail.gmail.com>
Date: Sun, 7 Mar 2010 11:01:39 +0000
Message-ID: <56d259a01003070301r7d5bbb9y56b01fa794c4bcc7@mail.gmail.com>
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
From: Martin Guy <martinwguy@gmail.com>
To: dave b <db.pub.mail@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/10, dave b <db.pub.mail@gmail.com> wrote:
> Ok... however how should one test the memory of an arm machine? ...
>  memtest is only for x86. *I am referring to the kernel memtest and not
>  memtest86.

Well, there's a userspace one: follow the link from
http://www.arm.linux.org.uk/developer/stresstests.php

    M
