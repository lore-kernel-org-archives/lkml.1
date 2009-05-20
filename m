Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZETPG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZETPG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZETPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:06:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:49263 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZETPGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JVGt92VLaEJbUmkr8D/bXyreQGwlA1RqMiVDdQ/kduDR1CiG+NrNsFYBUR92mp6RUW
         mDqr+kzJ6+QJCYLK/JN/FRhXS9YbzFvQUElYgWrW60HOjUdbPpoDNyn/Ex9ijklxBHdT
         7uXplT+1sJdrSlDCAgyPj20QCnmPOxUkY78is=
MIME-Version: 1.0
In-Reply-To: <20090520053031.GC13453@kroah.com>
References: <20090520053031.GC13453@kroah.com>
Date: Wed, 20 May 2009 08:06:51 -0700
Message-ID: <5ab239b10905200806h78e2649cy1aa7408fd6653262@mail.gmail.com>
Subject: Re: Linux 2.6.29.4
From: "D. Kelly" <user.kernel@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  I have just updated my kernel from:

ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.4.tar.bz2

However, I am getting some errors after I `make menuconfig`:

exec make kpkg_version=12.013 -f
/usr/share/kernel-package/ruleset/minimal.mk debian
DEBIAN_REVISION=Build.1  APPEND_TO_VERSION=.amd64-x2.052009.1
tail: cannot open `debian/changelog' for reading: No such file or directory
dpkg-parsechangelog: failure: tail of debian/changelog gave error exit status 1


I've never had this problem before so was debian/ accidentally left
out or is it intentionally gone now?

Thanks guys.
Derek
