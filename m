Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbYBYGvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbYBYGvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBYGvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:51:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:55627 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYBYGvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HJ9EwZOPesAd/i/Tb+Phmof60VpM4FPVw54J0D0ANFc/6rLMv9dfoRVGelU4CgNp9LvHARecW3Ip+pZsKiVm7jhq/TZ9SKwvz7Yil7vIo9noFMBYJyEG49E9VFedYP4BlpqAljvHi5TpNadyGJKcz/M4eRB4tcT7MNkhkoyW0PM=
Message-ID: <4d8e3fd30802242251p7a45482dof23aed1eed0afdc2@mail.gmail.com>
Date: Mon, 25 Feb 2008 10:21:01 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Cc: "Benny Halevy" <bhalevy@panasas.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080225032944.GA30294@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114232913.2555d392@paolo-desktop>
	 <20080128145605.GI12910@shadowen.org>
	 <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com>
	 <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com>
	 <47C18AAB.7050503@panasas.com>
	 <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com>
	 <20080225032944.GA30294@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/08, Andy Whitcroft
> As we want the messages to be as short as possible, I am leaning towards
> standardising on:
>
> spaces prohibited <where>
> spaces required <where>
>
in that case i would prefer:
 space not required <where>
 space required <where>

ciao,
--
Paolo
http://paolo.ciarrocchi.googlepages.com/
