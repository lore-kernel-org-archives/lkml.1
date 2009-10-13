Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbZJMGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbZJMGoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933024AbZJMGoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:44:20 -0400
Received: from mail-qy0-f186.google.com ([209.85.221.186]:44173 "EHLO
	mail-qy0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbZJMGoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:44:19 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 02:44:19 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mDBpruAMIyV+Gkerke45wfhHbg01xNL1qbhVFBy2ZYeU/9uMDQYuPlSBmPkOQ01a6o
         +OJ6MVyLKf94Ly+LZQSp9+fTgqR5u9wVzitWznESqXXc/fcM807wHOCb2iKJSyIDVm+p
         YjfID1N8wzb6ch9msi8ekoOfIHf2cLMKDxpY8=
MIME-Version: 1.0
In-Reply-To: <20091009141538.GA22861@tuxdriver.com>
References: <95455e980910090412i32f401abmf4cc901be2e9acc8@mail.gmail.com>
	 <20091009141538.GA22861@tuxdriver.com>
Date: Tue, 13 Oct 2009 17:37:22 +1100
Message-ID: <95455e980910122337y9e1186ft90cb78204bdd671c@mail.gmail.com>
Subject: Re: support TOE
From: hce <webmail.hce@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 1:15 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Oct 09, 2009 at 09:12:20PM +1000, hce wrote:
>
>> Which Linux kernel version supports TOE (TCP Offload Engine)? Or not
>> at all, I have to use TOE patch?
>
> Google is your friend...
>
>        http://www.linuxfoundation.org/en/Net:TOE
>

Nice article, but it does not mention if the current kernel supports
TOE or not. Anyway, I downloaded the latest kernel 2.6.31.4, and
checked source code. There is nothing to indicate supporting TOE. My
conclusion is as of today, Linux kernel does not support TOE, please
correct me if my conclusion is wrong.

Thank you.

Cheers.

jupiter
