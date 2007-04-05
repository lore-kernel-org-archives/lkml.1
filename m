Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXDEEN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXDEEN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXDEEN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:13:58 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:48419 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXDEEN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ihHfN5pdrDxLO9w1f9mfZ5ciJt5oSxBkNrOcaIgCW+2lU5IMXpJ1kZA4SQxAm5yXMNagWCSjndHDQpx0S2SP1RKQ6tWZzO+WpY6xTMsPk1pbHvBSv5KRq81zHNumZeQKVpc+5CLaWfAEwztVQ7Y4Fvu64cgE7yLr0MeaR5zJpsE=
Message-ID: <75b66ecd0704042113mebd1275w2fa40bf159416811@mail.gmail.com>
Date: Thu, 5 Apr 2007 00:13:55 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Cc: "Tejun Heo" <teheo@suse.de>, linux@horizon.com, dan.j.williams@intel.com,
       linux-ide@vger.kernel.org, neilb@suse.de, cebbert@redhat.com,
       jens.axboe@oracle.com, linux-kernel@dale.us,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <46143338.3020808@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070323174630.31051.qmail@science.horizon.com>
	 <4611EADC.3000306@suse.de> <46143338.3020808@tmr.com>
X-Google-Sender-Auth: 58740fb22d4f5f8a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Bill Davidsen <davidsen@tmr.com> wrote:
> I won't say that's voodoo, but if I ever did it I'd wipe down my
> keyboard with holy water afterward. ;-)
>
> Well, I did save the message in my tricks file, but it sounds like a
> last ditch effort after something get very wrong.

Would it reallty be an impediment to development if the kernel
maintainers simply refuse to merge patches that add new sysfs entries
without corresponding documentation?

Lee
