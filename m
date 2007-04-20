Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXDTEy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXDTEy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161128AbXDTEy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:54:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:37632 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161126AbXDTEy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qOojI0at6P98iM/FYTTvH9DuwrhiAcZu5+KvwgyMPXt5P79fshaYzMLuqy7j8ODH2mIBviVIXqndTBzQ0pLVsTYIMV1gSfyvhvKWHpQgJmJ/JIoR7eysFZjGb2u65W+PIbTQHfK3bdcPTKMv8FAUtJ+QHsT76HWvOKBsH8cU258=
Message-ID: <9c21eeae0704192154r5abec14ax242f9c40bab09728@mail.gmail.com>
Date: Thu, 19 Apr 2007 21:54:56 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL] kvm oops fix
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1176997839110-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176997839110-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Avi Kivity <avi@qumranet.com> wrote:
> Linus,
>
> Please pull from the 'linus' branch of
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git
>
> To get a one-liner fixing a host oops running  non-pae guests.
>
> Avi Kivity (1):
>       KVM: Fix off-by-one when writing to a nonpae guest pde

Ooo I thought of something else.
Should this be applied to the current 2.6.20.7 for the next 2.6.20.8 release?

- David Brown
