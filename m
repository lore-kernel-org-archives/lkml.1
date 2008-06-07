Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYFGCjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYFGCjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYFGCi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:38:59 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:51077 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYFGCi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tvFebqi9j04GYEwsj9KXk87FLQ8BUJiEF2C5jFiIRRV7ExHOlOCrflzFQCXQ22MK48
         jJMYoD95cIq2fReDgFSUfwpwx5wo6bNDT/Kg5SV8kvKV+7bUXBeLvulqhTlF/xZ7KWgH
         KrFZ5mNl3011wgPijMrhm25/p0jjNUhVDihsE=
Message-ID: <dd18b0c30806061938g95cfafbm69804bb38c13ed74@mail.gmail.com>
Date: Sat, 7 Jun 2008 02:38:56 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <873anq5a2b.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
	 <20080606121136.GA9087@srcf.ucam.org>
	 <20080606110711.a9a6a4f6.akpm@linux-foundation.org>
	 <dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com>
	 <dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com>
	 <20080606185548.GB8576@kroah.com>
	 <20080606192135.GA16727@srcf.ucam.org>
	 <20080606123511.38ffbdde.akpm@linux-foundation.org>
	 <20080606194856.GA17708@srcf.ucam.org> <873anq5a2b.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 1:05 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>
>> Different tools generate slightly different formats of the isight
>> firmware. Ensure that the firmware buffer is not overrun, while still
>> ensuring that the correct amount of data is written if trailing data is
>> preseent. Fixes crash reported by Justin Mattock.
>
> You don't like the word `present', do you? ;)
>
>        Hannes
>

pre seent meaning sent ahead of time,
or present as in time now, right on the spot. as for the word present
for liking +"I guess the kind at christmas time" : -)
regards;


-- 
Justin P. Mattock
