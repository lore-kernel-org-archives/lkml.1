Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYE3VJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYE3VJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYE3VJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:09:25 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:58618 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244AbYE3VJY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:09:24 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 17:09:23 EDT
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeff Garzik <jeff@garzik.org>, David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>
	<20080528.225826.40264516.davem@davemloft.net>
	<1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>
	<1212077700.26088.83.camel@shinybook.infradead.org>
	<483F002E.5060002@garzik.org>
	<1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
	<483F3EC4.5050700@zytor.com> <20080530103107.4f71cfe3@core>
	<1212141059.12349.240.camel@twins>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Fri, 30 May 2008 18:08:32 -0300
In-Reply-To: <1212141059.12349.240.camel@twins> (Peter Zijlstra's message of "Fri\, 30 May 2008 11\:50\:59 +0200")
Message-ID: <ortzgfebzj.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2008, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> It's what benh said; I just want a single netbootable image. And cross
> buildling initrds is just impossible - which makes the whole solution
> useless.

Unless you actually use the feature added in the first patch of the
series, that enables you to build firmware images into your single
netbootable image, that is ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
