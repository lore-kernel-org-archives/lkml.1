Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbXGaNwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbXGaNwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXGaNwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:52:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:30091 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbXGaNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eY9o/OAVlH2PLbwo2F6c2rGuJZqvnkFM3XKk1hz43/gPMSMRNPCAdKmBiKGW9mENE9cWqRUUOFIukTflFpYmx7tusaKheBN9z4G4sVA/GXfLtJbjXzWVLfJ3rucNmWYZD3+fNbeAjh5hCt7Mo7/HWzIw8zk9nMTzwTWR19xVIcw=
Message-ID: <9a8748490707310652i27406292yf3e93ca78ef3bf32@mail.gmail.com>
Date: Tue, 31 Jul 2007 15:52:30 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "2004 ruffneck" <ruffneck2004@yandex.ru>
Subject: Re: How to enable XEN in 2.6.23-rcS kernel?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <39811185887611@webmail12.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <39811185887611@webmail12.yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/07, 2004 ruffneck <ruffneck2004@yandex.ru> wrote:
> Hello to everybody!
>
> I did read, that Lguest and Xen was merged to upstream and must be in 2.6.23-rc1 kernel, but I can't see it in "make menuconfig". So, what's the deal? Can anybody explain me, how to enable XEN support? Thanks.

Go to "Processor type and features" - then enable "Paravirtualization
support (EXPERIMENTAL)", you'll get a new option called "Enable
support for Xen hypervisor".

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
