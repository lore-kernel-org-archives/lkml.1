Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZG2Lq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZG2Lq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZG2Lq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:46:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51963 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754130AbZG2LqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:46:25 -0400
Date: Wed, 29 Jul 2009 12:45:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: James Morris <jmorris@namei.org>, Miloslav Trmac <mitr@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG: scheduling while atomic reintroduced
Message-ID: <20090729124501.4161b9c6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090729082826.GA3208@localdomain.by>
References: <20090729082826.GA3208@localdomain.by>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 11:28:26 +0300
Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:

> Hello,
> who is tty maintainer at the moment?

There isn't one but Linus and Ogawa are currently working on fixing the
bug whose incorrect fix in the last -rc causes your bug
