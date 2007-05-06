Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXEFSTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXEFSTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbXEFSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:19:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:35001 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbXEFSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V6A8IAKBpUU4Jq87REk7CHoBI+uP8uJPztjmG/62ZQn/E1ea4IgqJFK1JDlTb45VNAkNpHj6Y5cTu0I3trUZjY7cmW9t4G47b/IZOI9VZ3l5QPZ9PFrFO2c0+CsAHE2XTJbu2xnogNgn8s/NjCycWjPGxkTlQB8yeT2CDaEDD0M=
Message-ID: <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
Date: Sun, 6 May 2007 20:19:28 +0200
From: "Francesco Pretto" <ceztko@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Cc: "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <463B99EE.2090001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>
	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>
	 <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/4, Tejun Heo <htejun@gmail.com>:
> Yeap, the third iteration of the patch just got submitted.
>
>   http://thread.gmane.org/gmane.linux.ide/18485
>
> Unfortunately, there doesn't seem to be an easy way out.  We'll need
> userland shutdown(8) update.
>
> --
> tejun
>

Ok, i can't understand if the patch will be included in 2.6.22 (i
didn't see it in the Andrew Morton merge plan). However, if you can
confirm the inclusion, i can send bug reports for ubuntu and gentoo. I
can even send an email to Miquel van Smoorenburg, who should be the
mainstream sysvinit developer (and probably the last maintainer).

Francesco
