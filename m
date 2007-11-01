Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXKAKrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXKAKrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXKAKrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:47:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:47288 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXKAKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xq3vCOnTymKZXcoEbCLRvqQMiZQWAhqOT1O4nCfuDx5rRnzN+5m2N6PTXgBVVC6DnIZnN+t0adxI9CZDoYBqCG5JKBJd2oUlfhyohH1cx4XkmxoHxQwaHgleOHA+QWypPtIjwlG5uhwnt+hzXJCoSiAkO7qovqbmxzHlHytweAc=
Message-ID: <35fbaa3e0711010346y5963d929w5054fabad1569d66@mail.gmail.com>
Date: Thu, 1 Nov 2007 12:46:58 +0200
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "David Griffith" <dgriffi@cs.csubak.edu>
Subject: Re: fixing usb-midi device support
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 10/31/07, David Griffith <dgriffi@cs.csubak.edu> wrote:
>
> I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
> unit works fine with current kernels.  The MOTU unit won't work with
> kernels newer than 2.6.17.  I stumbled over a patch that had something to
> do with a MOTU Fastlane, but I haven't been able to find it again.  Could
> I get some advice on fixing MOTU Fastlane support?

I can see that you already had a discussion on this issue:
http://lkml.org/lkml/2007/8/10/102

Any results? Do you still can see the oops?

Vitaliy
