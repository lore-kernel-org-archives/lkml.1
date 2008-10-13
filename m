Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYJMVfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYJMVfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYJMVfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:35:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59824 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYJMVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:35:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DN79zUDyU7WBeuF9Gu26YuFQNX2M/Ptqgu6f7pESGfjvL34vVhnjsGFdh3emuq2UC
	ecRtsx5nWUFLBff7yGCcQ==
Message-ID: <da824cf30810131435v6756ed7cg264bbb0d09c0ac08@mail.gmail.com>
Date: Mon, 13 Oct 2008 14:35:11 -0700
From: "Grant Grundler" <grundler@google.com>
To: "kenneth johansson" <ken@kenjo.org>
Subject: Re: weird throughput on write to SATA disk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223925629.3947.7.camel@duo>
	 <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>
	 <1223932956.3947.22.camel@duo>
	 <da824cf30810131434r34179666kc8d075c7eecdbbae@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 2:34 PM, Grant Grundler <grundler@google.com> wrote:
...
> Can you try "dd oflag=direct if=/dev/null of=/dev/sdb bs=64k"?

sorry...meant to type "if=/dev/zero"...I don't recall if /dev/null
will work the same.

grant
