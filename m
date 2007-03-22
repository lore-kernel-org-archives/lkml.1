Return-Path: <linux-kernel-owner+w=401wt.eu-S934198AbXCVTkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbXCVTkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934200AbXCVTj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:39:59 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:3020 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934199AbXCVTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FmwiuyeL2nYhHFbsZililtXguNlOhcv7S31gNB9quamXMd7jfH8OuMhYbBzj1iwm4/TfHw7PfPDvuSpg9p5aN7qMAauIMvzsGOrFQDrc93q0hssYyc+39uZ6pMtSARjHq2xJ28Y2gQSRktq+NHW0nnUerWe41xPxGuSmoVma4II=
Message-ID: <8bd0f97a0703221239h14e50cfdhec648e325d7a57ca@mail.gmail.com>
Date: Thu, 22 Mar 2007 15:39:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] FDPIC: Fix the /proc/pid/stat representation of executable boundaries
Cc: torvalds@osdl.org, akpm@osdl.org, rgetz@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070322122919.31568.99690.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070322122919.31568.99690.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, David Howells <dhowells@redhat.com> wrote:
> Fix the /proc/pid/stat representation of executable boundaries.  It should show
> the bounds of the executable, but instead shows the bounds of the loader.

heh, and here we were thinking this was by design :)
thanks
-mike
