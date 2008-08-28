Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYH1Qd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYH1Qd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYH1Qds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:33:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:39603 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYH1Qdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J0DZGzpagktYEbAzjIaUhX/aCI6E3Gs8Oq26Zrq1LcF6q6vT/+V/2bEnFLSOuvOd03
         DW4DxHJWJ4asN7rQRvz2SHZhmmZOCE66D4iJvc61vfN1tYVPklvM7DqMs+VS4kswvzfZ
         NqGgYalTf4a2K7aRvjmtM7sAsfxdv+2skkR5g=
Message-ID: <b79f23070808280933t4e2caa9dt8962521c7e5e58e9@mail.gmail.com>
Date: Thu, 28 Aug 2008 09:33:45 -0700
From: "James Ausmus" <james.ausmus@gmail.com>
To: "Robert M. Stockmann" <stock@stokkie.net>
Subject: Re: libata, Sound on same IRQ : flaky sound
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44.0808280320470.31973-100000@hubble.stokkie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B5F877.8030506@garzik.org>
	 <Pine.LNX.4.44.0808280320470.31973-100000@hubble.stokkie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 6:30 PM, Robert M. Stockmann <stock@stokkie.net> wrote:
<snip>
> installing a recent kernel is not that easy, as the required
> upgrade of udev will break the initscripts and a lot of installed
> services and even the functionality of the KDE desktop. Installing
> a recent distro is not desirable as they resemble me only
> of a Open Source Vista distro, where it takes months to clean
> up the unwanted garbage and bloat inside. Its preposterous that
> a upgrade to a recent kernel mandates the installation of a recent
> distro. I run Mandrake 10.1 with kernel 2.6.15 and some applications
> upgraded like firefox, mplayer and k3b etc.
>

Not to divert this into a distro discussion, but you should look into
Gentoo (http://www.gentoo.org) - it offers the kind of customization
and flexibility (as well as pick and choose update capabilities) that
it sounds like you are interested in.

-James



> Robert
> --
> Robert M. Stockmann - RHCE
> Network Engineer - UNIX/Linux Specialist
> crashrecovery.org  stock@stokkie.net
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
