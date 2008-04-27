Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYD0JKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYD0JKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 05:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYD0JKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 05:10:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:49004 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYD0JKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 05:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iRZYGHL+PKcwYKjJWgsMYs0g8Ut1vw5qFkul2aUqp3Yr1TIU/S8MCvwd+gqdM6WUAogZGI8U6679VFsGkYuPlP2KcCfO/z0etOzl9K4e1/6750OB2KQSUW8VEL2MFZkLXH5vLGz1H4178DyxK6WnV93pqJBRXSAaHLy2f+LzAMk=
Message-ID: <ed10ee420804270210y219ac4dbne858906233ab9691@mail.gmail.com>
Date: Sun, 27 Apr 2008 02:10:06 -0700
From: "SL Baur" <steve@xemacs.org>
To: "David Miller" <davem@davemloft.net>
Subject: Re: CONFIG_OPTIMIZE_INLINING
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
In-Reply-To: <20080426.230807.144232984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426.215513.141243565.davem@davemloft.net>
	 <20080427055943.GA16290@elte.hu>
	 <20080426.230807.144232984.davem@davemloft.net>
X-Google-Sender-Auth: 7fb91c12bb70801a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, David Miller <davem@davemloft.net> wrote:

>  Because anyone who is paying attention can see clearly that you're
>  trying to push as much stuff as quickly as possible into Linus's tree

I'm giving up for the moment trying to review anything.  I can't contribute
by compile testing a lot of stuff - I don't have a farm of computers that can
build and boot thousands of kernels overnight, nor a machine that can build
a kernel in 2 minutes, nor a suite of cross-compilers that can test
build patches
across all the architectures we support.  I'm not paid to follow any of this, my
only paid concern is Linux userland and so following Linux Kernel is a hobby.

If you, Ingo, are going to push patches in before they can be reviewed, what
reason is there for anyone to bother trying?  (The patch I was trying to review
that you merged before review was complete was different than this one).

Oh and Thank You! David for starting to post your git pull messages.  Idiots
like me read those sorts of things and appreciate it *very* much.

-sb  (I *like* reading patches and I want to contribute any way I can)
