Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbXIPNTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbXIPNTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbXIPNTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:19:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:37550 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbXIPNTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DuqCAsoaB/pYJxfq7gq1g6xFW6qHbk0Rut1OjVAUifV6cGprVYjs9/bgoxDa36z+JYyn/4lFxakZCvTNYQRRm+lzf7P8zmTQc00IXbn7ypXoMnvCVxFVXrMuzKyKacRxMgxWqh1ewzDNkfB4R3COun7kTcQiUXxZbsvTSjdBikQ=
Message-ID: <a781481a0709160619g312dc334w8c610fc13a9d1ef1@mail.gmail.com>
Date: Sun, 16 Sep 2007 18:49:42 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Cc: linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>, linux-acpi@vger.kernel.org
In-Reply-To: <a781481a0709160347t647fab9fs505dd053f3fe203d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695EC25.6050003@arcor.de>
	 <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
	 <200707122040.36800.david-b@pacbell.net> <4699F9CB.5010407@arcor.de>
	 <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
	 <a781481a0707150429y22b8b10bv413f5f6ba498d3e4@mail.gmail.com>
	 <469A09C9.6000608@arcor.de>
	 <a781481a0709160343l530b067bg55a4679e1cf864ab@mail.gmail.com>
	 <a781481a0709160347t647fab9fs505dd053f3fe203d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, opened up: http://bugzilla.kernel.org/show_bug.cgi?id=9026
and brought it up to date with the discussion and David's comments on this
thread. Timo, please feel free to revisit this later and update us when you find
the time to do so.

[ BTW I think the "add CC:" thing in bugzilla is broken, I was simply unable to
  add David Brownell, linux-acpi@ and Timo to the CC: for that bug, if somebody
  knows how to do this, please add them ... ]

Thanks,

Satyam
