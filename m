Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbXJYUlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbXJYUlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXJYUlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:41:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:27818 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762502AbXJYUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sTOBDydB1Fo9D1azLtdqkrJZPlzCHxqzJa2N0BRmnWYOo+hHLiQdkY4g5Cq4U8cFS/cmhSQx+eBTuobcGI+PFqEUFsidEDs1Nye8GQWUSEkJtCxK47B6HIFc9q0vdBghUII/YUNXqr2aFlSCs0OKRjTD6docVjYxTwIgXU4NNjQ=
Message-ID: <4720FF2B.9020802@googlemail.com>
Date: Thu, 25 Oct 2007 22:40:11 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Michael Lothian <mike@fireburn.co.uk>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net>	 <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com>	 <20071025185022.GP30533@stusta.de>	 <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com>	 <20071025191723.GQ30533@stusta.de>	 <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com>	 <20071025195020.GS30533@stusta.de> <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
In-Reply-To: <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Lothian wrote:
>> The MPENTIUM4 option does not only set -march=pentium4, it also enables
>> several other options in arch/i386/Kconfig.cpu resulting in better
>> performance.
> 
> How about an autodetect to set the right options here too using cpuid?
> 
> With a warning of course that the code produced will be specifically
> for the native cpu that it's compiled on.

And kill off all Distro kernels right ? IMO to set that auto magically is bad.

Regards,

Gabriel 

