Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYJGVEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYJGVEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYJGVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:04:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJGVEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:04:30 -0400
Date: Tue, 7 Oct 2008 23:10:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081007211038.GQ20740@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name> <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, no.
> This description still doesn't explain why this interface is needed.
> 
> The one of the points is this interface is used by another person or not.
> You should explain how large this interface benefit has.
> 
> Andi kleen explained this interface _can_  be used another one.
> but nobody explain who use it actually.

Anyone who doesn't want to use fixed addresses. 

-Andi

-- 
ak@linux.intel.com
