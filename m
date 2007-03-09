Return-Path: <linux-kernel-owner+w=401wt.eu-S1767265AbXCINXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767265AbXCINXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767275AbXCINXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:23:48 -0500
Received: from hu-out-0506.google.com ([72.14.214.231]:27826 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767265AbXCINXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:23:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E34I/GcuKfdfYQzferfEYv1Wp3wroiQdJsMpvYvpjO18yLtsF9f/BSyfL45N2JwnkLHYyYyTCZd5mvLsOBYQC1or1TwP91ScbPD9lu84zX1dAXn9emkLde147zQaoszZeJ3rX7z8yW9fKSOaAlxX1HgyNevCEnnOUJaIoILfYQ0=
Message-ID: <1e1a7e1b0703090523l5602f325k17560a9ee0b467e5@mail.gmail.com>
Date: Sat, 10 Mar 2007 00:23:40 +1100
From: James <iphitus@gmail.com>
To: "Ivan Babkin" <ivan.babkin@miclab.chem.msu.ru>
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D4E000.6050403@miclab.chem.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D4E000.6050403@miclab.chem.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Ivan Babkin <ivan.babkin@miclab.chem.msu.ru> wrote:
> Thank for the job you've done!
> Your driver works with 1 Gb sd-card (x86_64 suse's 2.16.18.2 kernel).
> Read rate for me was around 250 Kb/s, write - 28 Kb/s (using dd utility).
> BTW, I get continuous flow of "sdricoh_cs: timeout waiting for data"
> messages in dmesg.

Works for me too. Using a 512mb SD card, and a 256miniSD in an adaptor.

Managed to mount both SD cards and play mp3's off each with mpg321.
Literally music to my ears. I used the 0.1 release on the homepage, so
it still oopsed on removal when I hadnt unmounted.

Laptop is an Acer Travelmate 370 for the record.

James

-- 
iphitus // Arch Developer // kernel26beyond // iphitus.loudas.com
