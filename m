Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYEXXI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYEXXI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYEXXIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:08:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:37692 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYEXXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EwJoyQWMtgsTAUV8Y+PVr+rU2I4ynz3J5LYD6+xUe00OMAiDkraAJbxaHKDz9jjJ4RHWfyalFptViran/3gC9GKQ6+CYpIz95GOQa35CAo+H3o7yBRkh43YzL69m1dpAobNrHeZ/tarWKkE+GkyykkXgK34ERd7OiTnGJ2n3yHQ=
Message-ID: <dd18b0c30805241608o35915aa9l3759b5a50785279@mail.gmail.com>
Date: Sat, 24 May 2008 23:08:16 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI : EC: GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <TW_YzGo9TFP.A.erD.jeIOIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
	 <TW_YzGo9TFP.A.erD.jeIOIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 8:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI : EC: GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (9 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121091875711824&amp;w=4
>                  http://lkml.org/lkml/2008/5/18/168
>
>
>

Hello; This message seems to be appearing on a random, (every x amount
of boots). At first I thought this was resolved with adjusting the
.config
but didn't seem to be the answer. Also I have third party modules
installed i.g.(isight driver, and dri driver) which also might be
causing this.
I guess the best answer is if somebody else can verify this happens to
them, with all in kernel modules. I on the other hand will unload
the third party modules and see if this appears.
regards;


-- 
Justin P. Mattock
