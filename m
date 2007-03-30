Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXC3CRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXC3CRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXC3CRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:17:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:26344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXC3CRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iBA1CwjrkgNMbqGoAM3WpGOjT6yP3UzyGCEnBoJo2cDoTPhg3tzZ5CgRiwwmEUdX1Ur2q+l/Ivr19BKucGug50cIMQyaELcjgHUsA3+0a2ERZSO2gbcTPzOhgalIz52bh+VJGYf4MgpD0PePQAp6Z5XT54O5SGvuwQWGzAVTA18=
Message-ID: <75b66ecd0703291917x4f497f53s464663a1e8a0fa3c@mail.gmail.com>
Date: Thu, 29 Mar 2007 22:17:27 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ed Sweetman" <safemode2@comcast.net>
Subject: Re: 2.6.21-rc4-mm1 and rc5-mm2 - problem with cpuidle routine
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Larry Finger" <larry.finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <460C670A.9060204@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <1174433034.62033.16.camel@localhost>
	 <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	 <46017E56.7050400@lwfinger.net>
	 <20070321133815.304eb256.akpm@linux-foundation.org>
	 <20070322003315.GA17996@linux-os.sc.intel.com>
	 <460C670A.9060204@comcast.net>
X-Google-Sender-Auth: 465f283ebc120379
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Ed Sweetman <safemode2@comcast.net> wrote:
> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
> PCI: Setting latency timer of device 0000:01:00.0 to 64
> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
> **WARNING** I2C adapter driver [NVIDIA i2c adapter ] forgot to specify physical

Please try to reproduce with an untainted kernel.

Lee
