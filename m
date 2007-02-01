Return-Path: <linux-kernel-owner+w=401wt.eu-S1030570AbXBAJD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570AbXBAJD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030520AbXBAJDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:03:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:28155 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030570AbXBAJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j8l717W4cbTHAqT3H8GE9AHzTCOdfVlv76iYI2NdBEhAF0iDDR36HgiK56womDb2Vj2yvJQY7i+PiODoyHxM3P0Jc0g+YistSk7zwgBq+lBecqq9vQHyLMEV7qSfcJAsabYgkludGxKHVktZVT9OgOlwj7QgHQ6KNoLSSkqPmaY=
Message-ID: <3d57814d0702010103m4d7c3577q35b7f5fff16a716a@mail.gmail.com>
Date: Thu, 1 Feb 2007 19:03:22 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
Subject: Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, "Theodore Tso" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <54850.192.54.193.51.1170319212.squirrel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>
	 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
	 <20070131234450.GB32078@kroah.com>
	 <54850.192.54.193.51.1170319212.squirrel@rousalka.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Nicolas Mailhot <nicolas.mailhot@laposte.net> wrote:
> Well, reengineering nvidia/ati DRM is rude to ati/nvidia, so was creating
> tigon3, so was rewriting from scratch the GPL drivers some ATA vendors
> published in the past, so was spurning the SATA/SAS stack adaptec
> offered...

It is rude, but they're writing proprietary modules, and *that* is
rude, so screw 'em.

> If the answer is no, then there is a big pile of device documentation (in
> the form of source code) waiting to be used.

Greg didn't say it was rude to write a new driver without consulting
the author of an existing driver.. just that taking their code without
asking them if they would prefer to put it in the tree themselves is a
bit rude.

Admittably there is a point where this whole politeness thing could
get out of hand, but I think a good rule of thumb is to ask the author
if they're ok with you doing X with their code, and if they say no,
well, try to be gracious about it.  Not that they *should* say no,
this *is* free software after all.

Trent
