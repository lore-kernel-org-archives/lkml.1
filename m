Return-Path: <linux-kernel-owner+w=401wt.eu-S939709AbXGaFLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939709AbXGaFLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXGaFLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:11:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbXGaFK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:10:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=bHp2864Ip58s08W8GkDDD0384OO1Z+L5zVe4XJJaEeAbKw7vt+7GHoKcMFWmhG/d+
	a3mT6FddcOb0GuyeoWabg==
Message-ID: <65dd6fd50707302210y5b79a70di58eb2d46f3958025@mail.gmail.com>
Date: Mon, 30 Jul 2007 22:10:43 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Mark Fortescue" <mark@mtfhpc.demon.co.uk>
Subject: Re: [SPARC32] NULL pointer derefference
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/07, Mark Fortescue <mark@mtfhpc.demon.co.uk> wrote:
> Hi All,
>
> Unfortunatly Sparc32 sun4c low level memory management apears to be
> incompatible with commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
> mm: variable length argument support.

I feel like I ought to help out with this since it's my change which
broke things, but I don't have access to a Sparc32 box.  Does anyone
have a remotely rebootable machine I can use?

Ollie
