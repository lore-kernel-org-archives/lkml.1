Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXCKVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXCKVmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 17:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbXCKVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 17:42:05 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:39279 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXCKVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 17:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A+UfMh705/jHiWIWKFiYJzCci44sZoSO+jyyn1LWyT1SC33gaKBfKnHk4Yvty90bH3mbbShNOvCH2OZNLIGUHJwX7J/PEzWVSb7j6t3SayL3GiVdDjptpmMMhwuwlDuwy0oZhK9C5I0wvPp0moLMu3NA6YhPhkS71sO8cduFW34=
Message-ID: <75b66ecd0703111442v24f5b264rc9a8ef5d96f27375@mail.gmail.com>
Date: Sun, 11 Mar 2007 17:42:02 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Giuliano Pochini" <pochini@shiny.it>
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070311222652.5ea40da1.pochini@shiny.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070311222652.5ea40da1.pochini@shiny.it>
X-Google-Sender-Auth: c26109b573337d0e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Giuliano Pochini <pochini@shiny.it> wrote:
>
>
> Since 2.6.20 /sys/devices/system/cpu/cpuX/online isn't there anymore. The
> directories exist, though. I also tested linux-2.6.21rc3. I had a look at the
> archives and I found nothing about the removal of that file, which is still
> documented in Documentation/cpu-hotplug.txt. I don't know if other
> architectures are affected.

What is CONFIG_SYSFS_DEPRECATED set to?

Lee
