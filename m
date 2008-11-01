Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYKAT6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYKAT6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYKAT57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:57:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:63846 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYKAT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xKnVMHzPYcHGjNQxMO6ZSbpbYSflflF+Vx2JApgQrGlgwERUosB/Dls+YTv23RmN4Y
         2oyFxp1q+50VQNdzPZbaQFvdXJC6qPIKblMmTF/itP2sDtBccdCVMRZUBbYihp97ljxi
         svVi7lgsjvnHhreiBqSaXfz3BsNsE4kprU91o=
Message-ID: <3aaafc130811011257q3ee09f97ubc48c1871bd5df22@mail.gmail.com>
Date: Sat, 1 Nov 2008 15:57:58 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Artur Szymczak" <artur.szymczak@altkom.pl>
Subject: Re: Ralink RT2700E driver
Cc: linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>
In-Reply-To: <490CA461.4060501@altkom.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490CA461.4060501@altkom.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 2:48 PM, Artur Szymczak <artur.szymczak@altkom.pl> wrote:
> Hi,
> why WiFi cards with ralink chipset RT2700E are not supported by linux
> kernel?
> I found on ralink homepage driver for this chipset
> http://www.ralinktech.com/ralink/Home/Support/Linux.html (2860). And it
> works. Why it isn't added to kernel?
>
> Best regards
>
>

A driver for the 2860 has been added to Greg Kroah-Hartman's staging
tree. You can obtain this tree, a set of Quilt patches, here:
http://kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git/  (If
you need help getting the patchset, email me personally and I'll walk
you though it)

Now there do appear to be several other drivers on the webpage you
mentioned, and I'm not sure if all of those others are supported. Greg
could probably clear that up. But the 2860 support is coming.

~J.R.
