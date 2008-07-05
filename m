Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYGEHye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYGEHye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 03:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYGEHy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 03:54:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:4836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYGEHyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 03:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UOKfGJ+8uRxFc5J25LGKFanEU2vxle84+eKL/BatfKG6ZvAs8rS3b8z+sShImeFmjQ
         B5nFVPnW8HjQom/uzZE511gWpCHkm/miUvaRn7YcbT37lqGwfHQx32+fhnjA7ufVCCTm
         xp8ywCOnMrOx/Mc0d7+LjYgC4PnfayNQKeyEE=
Message-ID: <e2e108260807050054v44323b97s6bfbd0371beef51e@mail.gmail.com>
Date: Sat, 5 Jul 2008 09:54:22 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Linux 2.6.25.10
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080703172914.GA11123@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703035807.GA8190@kroah.com>
	 <e2e108260807031008r3de9aad7v8222d41fd750b9da@mail.gmail.com>
	 <20080703172914.GA11123@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 7:29 PM, Greg KH <gregkh@suse.de> wrote:
> The release notes are there in the shortlog in the email announcement
> and full Changelog on the kernel.org site for exactly what specifically
> was fixed:
>        http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.25.10
>
> If you have any specific questions about any of the individual changes,
> please let us, and the developers who made those fixes know.

Sometimes I have to backport bugfixes to older kernels. In that case
it's important to know in which kernel version the bug was introduced.
This info is included for some of the bugfix patches in the changelog,
but not for all.

Bart.
