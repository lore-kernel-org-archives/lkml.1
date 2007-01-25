Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXAYFeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXAYFeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 00:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbXAYFd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 00:33:59 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:44940 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXAYFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 00:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FAHVlYXthqBVT60mMTjSeeQmMTWQ1Ze0LvZuQWRNnQY+jdRJODmqAh0XbGOSG6NUHRVmRXwK86bc+HVlznef62eYrtCzvYfbR9NGNRBCIB+ETpnazBd+kX+iGQxCVXQxnLO4iIJyMLaGcDpnBfcs39QahYVmPBKLBMsxfjDHNEI=
Message-ID: <3877989d0701242133v2d554d45j603af0b597085fb9@mail.gmail.com>
Date: Thu, 25 Jan 2007 13:33:58 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Eamonn Hamilton" <EAMONN.HAMILTON@saic.com>
Subject: Re: IO-APIC + timer doesn't work - 2.6.20-rc5 on abit KN9-Ultra bios 1.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1169655700.22508.186.camel@ukabzc383.uk.saic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169630914.22508.151.camel@ukabzc383.uk.saic.com>
	 <3877989d0701240721lcba4833p76aa14802e3620f7@mail.gmail.com>
	 <1169655700.22508.186.camel@ukabzc383.uk.saic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Eamonn Hamilton <EAMONN.HAMILTON@saic.com> wrote:
> I've also just found bug #7820 on bugzilla which has a patch which may
> address this issue from Ingo.
>
> I'll give that a shot as well.
>

Yes, that patch workaround the problem. But it is just a workaround.
It would be much helpful to others by fixing the original problem.
