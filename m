Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXENDUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXENDUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXENDTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:19:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:13121 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbXENDTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qMuarUs07bFUvC4/sSJW4yuRP0iTrQ3a089F4Uzi4ztNDMSbMIOlF2WHRXVTQKKbSoQkBeB+rrRaSlwBYrCtco3RAQi/MnV0jks043jmmEN/klU+Tw2pXI1r2zYKM9OiDvBDe5icneR/C86GOk+XJ0/jiJgRXqAEIqZc+S+T0YI=
Message-ID: <b6a2187b0705132019x579bf28fq5110812432a3b591@mail.gmail.com>
Date: Mon, 14 May 2007 11:19:52 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: patch for vmware for Linux-2.6.21
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1179106529.19106.6.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0705131818x556eb57me42d1811e0db7a04@mail.gmail.com>
	 <1179106529.19106.6.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 2007-05-14 at 09:18 +0800, Jeff Chua wrote:

> I'm sorry... but why are you posting these patches here? Those aren't
> GPL modules, and thus very offtopic for lkml, maybe except for if you
> want to deliberately have people look at non-gpl code ;(

I don't like these non-gpl code myself, but it allowed me to use
Linux-2.6.22 as a base to test the new kvm and hope to migrate to kvm
soon, and I'm sure some others out there would benefit from it as
well. I don't claim the code to be perfect, but by releasing to
others, hopefully someone can tell me where to improve on.


Thanks,
Jeff.
