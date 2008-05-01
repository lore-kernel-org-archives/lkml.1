Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbYEAPC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbYEAPC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYEAPCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:02:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:15897 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYEAPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CWwyzJ79GMLwhjn2txEsrOsUaJTLx7eylJX9ZuYVlzlsYhwlxl6fxje9qXAmMvBkoQw1eplMTpQBZlJHVyMvWsVgwyd65HGrI5K73mOugKCZJWtNJ3KXb45UjC5xdvyhth0t7Dt0bn08o6eJK8t1JkbAotrnpbAKKoIEB0akeog=
Message-ID: <68676e00805010802s7b54f96ekbe637e5fb99dbd30@mail.gmail.com>
Date: Thu, 1 May 2008 17:02:43 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [BUG] smp alternatives: sleeping function called from invalid context
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080501130453.GA28965@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430195110.GA28743@dreamland.darkstar.lan>
	 <20080501130453.GA28965@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 3:04 PM, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:
> * Luca Tettamanti (kronos.it@gmail.com) wrote:
>  > Hello,
>  > with git current I'm seeing these warnings when bringing CPUs down:
>  >
>
>
>  Hi Luca,
>
>  Does your tree include the patch posted here ?
>
>  http://lkml.org/lkml/2008/4/19/139

Nope, I was using vanilla kernel (smp_alt is still a spinlock). Will
test the patch ASAP.

Luca
