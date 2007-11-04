Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXKDSwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXKDSwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXKDSwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:52:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:45973 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXKDSwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:52:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OX1VKkX+ZOjzz/s46DFXgCn8Wf/Esqcy7yNvDbeq2wJ/vJdayiGrheRucy2/ZbDAQ0rK2VpwfK5u2e3zAeMVdHNwAy7pGCM78Q0ccUM1EVTCACMf7ygT+DoGy4m3jxhSAazf0KQnhLwi4hApVNtV/R12x9X9i5FtK3ua6jqeraY=
Message-ID: <e5bfff550711041052m1c55571bx49c60dd6ce407d01@mail.gmail.com>
Date: Sun, 4 Nov 2007 19:52:31 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: List of possible duplicated include files in include/
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0711041347001.12818@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550711041044p7c07c42g836461e81a6005a@mail.gmail.com>
	 <Pine.LNX.4.64.0711041347001.12818@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> On Sun, 4 Nov 2007, Marco Costalba wrote:
>
> > Here the number of false positives is overhelming, but perhaps there
> > are also _real_ duplicated include somewhere in the bunch:
> >
> > include/acpi/acpi_bus.h:
> > #include <linux/device.h>
>
> ... snip header file output ...
>
> i deliberately left out header files from my script output.  i can
> tweak the script and add this to the web page as well.
>

Here the real job is to fliter out false positives more then print out
the list I would say ;-)

Marco
