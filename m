Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXDJOfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXDJOfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDJOfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:35:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:33950 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030722AbXDJOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mpDllzMVKPNgeP8OJWxO9a/cb44f1BsccqaCiwF9Odymyd/Zg201AJ/llvJ1ak9wVRYxo+RY1bAj539oYGJ022qZvX4ztiS9KUDsJFYSzhzg7+y4JaaI1qdh0w8P30oenexfm6i4VcXSZgEHDKC4tbttUrxu7Zk6b+pneRjhNI0=
Message-ID: <b6a2187b0704100735s733e2499k421e27cf650001f8@mail.gmail.com>
Date: Tue, 10 Apr 2007 22:35:40 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We should be getting close to a 2.6.21 release, so please update any
> regression reports you've done,

I couldn't get suspend-to-disk to work with 2.6.21-rc6. I've tried
set/unset CONFIG_NO_HZ/CONFIG_HPET_TIMER, but nothing worked.

With rc5 and Maxim's patch, it worked with CONFIG_NO_HZ unset.

This is on ThinkPad X60s.

Jeff.
