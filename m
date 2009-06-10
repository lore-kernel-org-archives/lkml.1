Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZFJKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZFJKF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZFJKFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:05:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60955 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139AbZFJKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:05:21 -0400
Date: Wed, 10 Jun 2009 11:06:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Elina Pasheva <epasheva@sierrawireless.com>
Subject: Re: linux-next: manual merge of the usb tree with the ttydev tree
Message-ID: <20090610110617.58e73a37@lxorguk.ukuu.org.uk>
In-Reply-To: <20090610184114.fe8a849e.sfr@canb.auug.org.au>
References: <20090610184114.fe8a849e.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 18:41:14 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg, Alan,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/sierra.c between commit
> 968b6bc702be2b0953212f1ca56b1dc889c1c72d ("tty-usb-sierra-add-urb-funcs")
> from the ttydev tree and various commits from the usb tree.
> 
> There is some overlap between the ttydev patch and the usb patches.  I
> have just used the version of this file from USB tree (since it seems
> that there are many more changes there).
> 
> Please sort this out ...

Already working on this and getting all the patches into the ttydev tree.
Sierra are also now checking over my merge to check its ok.

Alan
