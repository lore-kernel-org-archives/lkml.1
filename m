Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXFBHEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXFBHEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 03:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXFBHD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 03:03:58 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:1308 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbXFBHD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 03:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OLhMw1gW1qVEnTovB+HcOEXGKY7xXozvo1hmgtF9fFK7HkY0tidsBKVO6LrKUCpd25dFHnd4bxXW8qoDfTWqcPxcEEN4jgerJGiz3XIAuJFbV80/TlFGZ8nm+NmLvAR/O3D8SaufWxKkSZygdDabKzPxranc+rK739Sm55uNdbE=
Message-ID: <fdaac4d50706020003g5f1658fewf6e0757aaa1c27bd@mail.gmail.com>
Date: Sat, 2 Jun 2007 16:03:56 +0900
From: "Jun Koi" <junkoi2004@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL][RESEND] KVM cpu hotplug fixes
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46604A05.6060507@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465FB8AA.6050504@qumranet.com>
	 <alpine.LFD.0.98.0706010819050.3957@woody.linux-foundation.org>
	 <46604A05.6060507@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On 6/2/07, Avi Kivity <avi@qumranet.com> wrote:
> Linus Torvalds wrote:
> > Don't send me pull requests like this. And absolutely do NOT send them as
> > resends. I just  get grumpy.
> >
> > If all the added code had been KVM-only, I might not care. But when the
> > bulk of the code touches core files, you had better explain why this is so
> > important that it cannot wait for the next merge window.
>
> Ok.  This was really wanted by laptop-carrying users, but I guess
> they'll have to wait for 2.6.23.
>

Could you explain a bit:

1) Why CPU hotplug is that important for virtualization?

2) Why this patch is wanted by laptop users?

I tried to answer myself those questions, but to no avail.

Thank you,
Jun
