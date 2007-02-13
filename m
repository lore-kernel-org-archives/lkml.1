Return-Path: <linux-kernel-owner+w=401wt.eu-S1750872AbXBMTyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbXBMTyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbXBMTyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:54:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:13611 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbXBMTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HnlOmsNlXoLnCEZm16wbn67GAgzh7+AqfXzFmXEDkoz/xfEYPEldgApSn5nks78JFnGpSJNxnW6eQkwYa2PNiKmyhlg49oMZk8UInf9OIq13Bpm4cgb4iTruCjXOYL6wXiOEhAGqitJboSaAFxn+MpJt7/mFiYy0+waHwsQCKzg=
Message-ID: <8d158e1f0702131153g6d9f748djb7556a1e9ebc71ad@mail.gmail.com>
Date: Tue, 13 Feb 2007 20:53:58 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LIBATA] Libata under Qemu
In-Reply-To: <8d158e1f0702130955n1ae4ebbew4bbf799d683c79fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702130955n1ae4ebbew4bbf799d683c79fc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> Hi,

Little errata, I only pulled Jeff's GIT at 15:00GMT , Linus' GIT was
from two days ago.
I just pulled linux-2.6-git8, same behaviour tho, it complains when
nothing is attached to the second channel.


Patrick
