Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYBQScR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYBQScR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYBQScB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:32:01 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:19748 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYBQScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gugITruqc7LYRIATez8RdD6HtkAY2Ur6QVn+FecOnaZDjWI1/mtK398W0rWObB5ymZxKwfAqLjQKWz/LIg9qXjq8S01pQYayN5lB4xAMLYo0NjDzHr3NUBYFg1IY92lyU/XHiAM2ieoLDo7aWvOQ5+9tI70O/cnyXI/tvtg5W9s=
Message-ID: <4d8e3fd30802171031g43325109g115caa4d1be60ba2@mail.gmail.com>
Date: Sun, 17 Feb 2008 22:01:56 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86: coding style fixes arch/x86/lib/csum-wrappers_64.c
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080217155000.GC22132@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080217145728.46ecdaa5@paolo-desktop>
	 <20080217155000.GC22132@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > [PATCH 2/2] x86: coding style fixes arch/x86/lib/csum-wrappers_64.c
> >
> > On top of the previous patch makes the file errors free according to
> > checkpatch.pl
>
> thanks Paolo, applied. (i've folded the two patches - as long as a
> cleanup patch has no effect on generated code we want to deal with it in
> a single unit)


Ok, i'll keep that in mind for the next patches.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
