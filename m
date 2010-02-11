Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0BKAwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:52:46 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:39203 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0BKAwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YhP74+qDo7MSbThQeyO6rP4I+WsKC4zVEtzfajFx2fMUoYTC1jYBg8gqDGb27A4Kyk
         qJaCb9G+cUwzdUxpaBRf1wQC+o0LNPT/k1gFiShiAs+PeU8xq5/6DSpf5t7dzBNaLVCt
         n1fEswjWickDi5JtPgd+ZEA5Rgt4ikNQNp8Rs=
Message-ID: <4B7354D9.50909@gmail.com>
Date: Wed, 10 Feb 2010 18:52:41 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: ST <st@iss.tu-darmstadt.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc7 problems
References: <201002092306.07449.st@iss.tu-darmstadt.de>
In-Reply-To: <201002092306.07449.st@iss.tu-darmstadt.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 04:06 PM, ST wrote:
> Hi
>
> I am currently running the linus main git tree with the last commit beeing:
> deb0c98c7f6035d47a247e548384517a955314a5 (2.6.33-rc7)
>
> USB Cardreader:
> Since i am now in my third attempt to get my usb flashreader going under this
> kernel (damn this must be simple right?). I have my doubts if this is probably
> not a .config but a kernel problem. If i plug in the usb card reader i get the
> output as attached in the file "usb_problems". The .config will be also
> attached. So i thought "ok, no problem i messed up", what about the defconfig.
> (arch/x86/configs/x86_64_defconfig).
> The defconfig works slightly better by omitting the repeating thread
> awake/thread sleeping output but no device is found usable. The distribution
> is Debian/Sid. The hardware is working with the standard Debian kernel 2.6.30.
> I had a similar error when i had an typo in the default codepage "utf-8" vs.
> "utf8". But this error is fixed now and USB Sticks are working fine.

Well, the card reader apparently reports medium not present.. is there 
anything in there? how is it not working?
