Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXJWS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXJWS3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXJWS3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:29:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:64112 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXJWS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SLfG3VSnC9BoTlsIaS95iGCUuUtZ1eGoQOe0zqA1Ux9OOY5V2/L8+pgJbvsdXfGYmTC0F189Rbfj7Evegxx1e8iHz1ntGLuNo0+nr0QomoQZQks8Kn5MFeOTc6xlQzhW8JukT66hCdwl47IO6e8n/hh7Jpzacm8BKL+0+rqvfcQ=
Message-ID: <9e0cf0bf0710231128r7d1e0218n1b954037faad738c@mail.gmail.com>
Date: Tue, 23 Oct 2007 20:28:56 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [BUG] rfcomm]
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <1193164006.6184.217.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
	 <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
	 <1193164006.6184.217.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> still another one to go :( Anyway since you have experience and you have
> a way to reproduce it, please test the latest kernel from Linus' Git
> tree.

I can reproduce this.
But I cannot use git snapshot as I have too much dependencies.

> I can also whip up a patch that disables the device_move() usage and see
> if that is the reason for the falling over.

This would be nice!
I can test separate patches.

Best Regards,
Alon Bar-Lev.
