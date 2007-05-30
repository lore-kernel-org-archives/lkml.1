Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXE3WbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXE3WbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXE3WbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:31:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:2771 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXE3WbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hZ6UpKFhuLnJIbR74jveHozl7h9WP1EREMgTrFHFx+6lYILpfON8AonFd5x54F1ecDsNxBhm9I7ZdnMFCejoJxE4mBLpwqwJpEH8oAn4La0SK/r0POMqlcNMyvNlmqhN1CeUIBCG+44J02rBvrBe0FsmUiPf/cokcdbHMYzp1cU=
Message-ID: <75b66ecd0705301531q1ba78d39od07d2611573c9150@mail.gmail.com>
Date: Wed, 30 May 2007 18:31:00 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: Compact Flash performance...
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
X-Google-Sender-Auth: 23e4097d9d232cda
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> I have a SanDisk Extreme IV 4GB CF card, capable of 40MB/s read, but
> am seeing 30MB/s read [1], connected directly to the IDE bus on my
> ICH8 controller.

How do you know it's capable of 40MB/s read?

Lee
