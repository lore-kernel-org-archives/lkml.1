Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbYCXQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbYCXQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYCXQ2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:28:52 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:32023 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbYCXQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BV0mcP2pcZ6W1CYsueFlVV7CFje7yqcXcAgfiV0lUGHaTu4tMB5CkmcHPiUjFGCZD/ERC98zu0kI63+9Cp8pFUQu7umzy8o2dUT3/W7aQnhuzU+JYrVwhTzs5iH9EZu+Qrbsn4YJdDtgzPVWLJbdPgQ1WVvj62y9zcIWhcZiIds=
Message-ID: <87a5b0800803240928n638937c3ib8e79f58cda2bb0e@mail.gmail.com>
Date: Mon, 24 Mar 2008 16:28:50 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: checkpatch [was: include/asm-x86/serial.h: checkpatch cleanups - formatting only]
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "David Miller" <davem@davemloft.net>,
       viro@zeniv.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <877ift8hre.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E647AC.1060906@gmail.com>
	 <20080323.051929.267232495.davem@davemloft.net>
	 <47E64BF7.4070808@gmail.com>
	 <20080323.053037.144236584.davem@davemloft.net>
	 <47E651BE.1080107@gmail.com> <877ift8hre.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Mar 2008 18:36:21 +0100, Andi Kleen <andi@firstfloor.org> wrote:

>  Also checkpatch.pl --file seems to be a good candidate for one
>  of the worst ideas ever merged (to be fair it was difficult
>  to see it would become that bad in advance -- but it got)

I have found checkpatch --file useful when taking large amounts of out
of tree code (a kernel arch subdir and a number of drivers) and trying
to get them into better shape for inclusion. In that situation it's
quite a good way of seeing how far off that goal I am. Running it on
existing in-tree code is more problematic.
