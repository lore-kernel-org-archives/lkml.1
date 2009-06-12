Return-Path: <linux-kernel-owner+w=401wt.eu-S932998AbZFLTLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbZFLTLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbZFLTL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:11:29 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53407 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZFLTL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T3947ETvjQX9z6M9F/M4qdZ5FjNEJ2Le36MDt0ICvldmEz1zUjkGPxkTYNXiexgDh1
         Yn0bVugyWbcCbl5zj+NkrITzDqFYn74SB1AfHaTLN+GLHg+KUvRR7ZnODFlsvxZIOj89
         jy5xCem2H6Y9nmWfdlHYKAvQsAn1FFwWnlVsc=
MIME-Version: 1.0
In-Reply-To: <20090609094451.GA26439@kroah.com>
References: <20090609094451.GA26439@kroah.com>
Date: Fri, 12 Jun 2009 21:11:29 +0200
Message-ID: <b637ec0b0906121211v515833c9l8a7856b4a463d63d@mail.gmail.com>
Subject: Re: [patch 00/87] 2.6.29-stable review
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

On Tue, Jun 9, 2009 at 11:44 AM, Greg KH<gregkh@suse.de> wrote:
>
> This is the start of the stable review cycle for the 2.6.29.5 release.
> There are 87 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by June 11 09:00:00 UTC.  Anything received
> after that time might be too late.

Are there any problems with this release?

>
> The whole patch series can be found in one patch at:
>        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.5-rc1.gz
> and the diffstat can be found below.
>
>
> thanks,
>
> greg k-h
>
>

Regards,
Fabio
