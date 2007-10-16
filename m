Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbXJPFoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbXJPFoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXJPFo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:44:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:38319 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXJPFoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GNhkuZRVy7zy1j/3ReM9DyLh14x8r5lvOL5i2YIMoBFRcuizSkebEUW/TfN6KVVVUJTPz1Oa0YpUYJMn7l811KrQWGZ7wzt4xYYfUKbr/TWnl8Y9LzV9d8DnNwtDqSiqMYJdQrOctLOVIqhzysOeN7caoS2GYQ3Q82BEw3KKjFs=
Message-ID: <2a382c6e0710152244r4b6e214dk93988263b193efa8@mail.gmail.com>
Date: Tue, 16 Oct 2007 09:44:24 +0400
From: "Dave Milter" <davemilter@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-2.6.23-mm1 crashed
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20071014123101.208b102b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2a382c6e0710141145j51286bd0o8a2eb307f7455cd@mail.gmail.com>
	 <2a382c6e0710141224n2b8a47c8v1346f1a9dedc7943@mail.gmail.com>
	 <20071014123101.208b102b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> I didn't notice that qemu was involved.  Does qemu have an emulator for the
> gdth hardware?
>

I think no, the kernel just probe exist or not hardware, and hangs after that.
