Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZG1TUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZG1TUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZG1TUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:20:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57852 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753462AbZG1TUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:20:00 -0400
Date: Tue, 28 Jul 2009 20:20:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic reintroduced
Message-ID: <20090728202055.3a55eacb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090728180008.GA3223@localdomain.by>
References: <20090728180008.GA3223@localdomain.by>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 21:00:08 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> Hello Alan,
> Looks like someone reintroduced "scheduling while atomic" bug.
> (rc4-git2)

Please talk to the new tty maintainer whoever that ends up. I no longer
care.
