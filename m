Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbYBNOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbYBNOeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYBNOeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:34:06 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:56980 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbYBNOeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:34:05 -0500
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: 2.6.24.2 won't compile UML
Date: Thu, 14 Feb 2008 15:33:56 +0100
User-Agent: KMail/1.9.7
Cc: user-mode-linux-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200802141213.09859.philipp.marek@bmlv.gv.at> <20080214142439.GA5901@c2.user-mode-linux.org>
In-Reply-To: <20080214142439.GA5901@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141533.56387.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 14. Februar 2008, Jeff Dike wrote:
> On Thu, Feb 14, 2008 at 12:13:09PM +0100, Ph. Marek wrote:
> >   make -C linux-2.6.24.2/ O=output_path/build ARCH=um bzImage
> >
> >   make[2]: *** No rule to make target `bzImage'.  Stop.
>
> This seems pretty clear, no?
>
> bzImage is a x86-ism.  Just leave it off, and you'll get linux and vmlinux.
Yes ... but the various warnings confused me.

Sorry, will try to do better next time.


Thank you!
