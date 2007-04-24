Return-Path: <linux-kernel-owner+w=401wt.eu-S1161760AbXDXNZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161760AbXDXNZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161763AbXDXNZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:25:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:60298 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161760AbXDXNZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BJc/IiKqaS7FFjykL+n3pzJVwRpA5FJplcgshxdoNB86rOw50z0Gg06eRkOIeMju5gwz7/bWGi40GMCo6ZaiBKkAVa52zLRVa92esgvKaVAxKtl/raAPBo8bQS7vSgGNofjxviL1isEhTrkllngoeMjzEjrxGvPaxdkFkZQiCZY=
Message-ID: <a36005b50704240625w2dd3ea42q77c12215b56b98@mail.gmail.com>
Date: Tue, 24 Apr 2007 06:25:27 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Pierre Peiffer" <pierre.peiffer@bull.net>
Subject: Re: [PATCH -mm take2] 64bit-futex - provide new commands instead of new syscall
Cc: "Jakub Jelinek" <jakub@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
In-Reply-To: <462DBABB.6090302@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321095432.207136068@bull.net>
	 <20070321100542.438317770@bull.net>
	 <20070327110757.GY355@devserv.devel.redhat.com>
	 <462CC449.6090004@bull.net>
	 <a36005b50704230830p2a4d55e2i61627b00788cd4d2@mail.gmail.com>
	 <462DBABB.6090302@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, Pierre Peiffer <pierre.peiffer@bull.net> wrote:
> Something like that may be...

Yep, looks goot to me.
