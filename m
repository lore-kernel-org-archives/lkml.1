Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXEKVLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXEKVLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760763AbXEKVLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:11:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:50790 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760600AbXEKVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wvg0hDg8BDOkWDOllm0uWr7IqWKq4RQXVUZzcOV4Sw563qa4xYv360cTrplItsq/QBEDP90PQHdWW/wUy4JMVnV0H+zkgrBUoXOVYABIn4rvd6yTLyasmvXwxBUy2ZAwJNw/MwksPmgMm8Rn3HaEqAhsJtnNve7NytFZ7Eo5YuM=
Message-ID: <2ea3fae10705111411g47e93fden3785b8f05c75ad63@mail.gmail.com>
Date: Fri, 11 May 2007 14:11:37 -0700
From: yhlu <yinghailu@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
Cc: "Pavel Machek" <pavel@ucw.cz>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>
In-Reply-To: <4644CFB0.10603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406154628.GG12005@jukie.net>
	 <m1zm4rd676.fsf@ebiederm.dsl.xmission.com>
	 <20070429094135.GA10948@suse.de> <20070511182329.GJ4052@ucw.cz>
	 <4644CFB0.10603@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Pavel Machek wrote:
> >
> > I do not think OLPC is using linuxBIOS these days. What they have
> > certainly looks like Sun's ROM monitor.
> >
>
> That would be OpenFirmware, then.
>
current kernel for x86 support OFW boot patch?

YH
