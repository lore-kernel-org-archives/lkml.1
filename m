Return-Path: <linux-kernel-owner+w=401wt.eu-S966139AbXDJJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966139AbXDJJTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966144AbXDJJTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:19:49 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:4517 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966139AbXDJJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MyyzCMXGrjoeKjwwEkhM0EVUlsSooER4xClYbRjM+YSNC8AcEACdNBx9UxPBqTtEfvuILfaH9C7EDV1+yGQOZQRXu5PV+AWcSgOWXqlKWDA3wCqCIbe1LycLAmI5TSEPBS3bFNZRDU/Ms9SDUnL1aSOV8aE8s7nrQtPKnPGVfBw=
Message-ID: <19061b0b0704100219w4749e5fby9b400edca9bf334d@mail.gmail.com>
Date: Tue, 10 Apr 2007 11:19:46 +0200
From: Bartek <poemann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
In-Reply-To: <19061b0b0704081315g3593d652s70e9b5b0dcfcf966@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
	 <20070407.234708.93384523.davem@davemloft.net>
	 <19061b0b0704081315g3593d652s70e9b5b0dcfcf966@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Apr  8 21:47:22 localhost kernel: EIP:    0060:[<c021b4d7>]
> Tainted: P       VLI

Someone  in private took me a noticed of a still tainted kernel. I
didn't noticed that, I am sorry for that. I was sure that unloaded
proprietary modules should resolve the problem. My fault. I will try
to reproduce the crash  again.

Regards Bartek
