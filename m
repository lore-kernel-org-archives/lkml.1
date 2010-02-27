Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674Ab0B0S6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:58:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38713 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030492Ab0B0S6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:58:31 -0500
Date: Sat, 27 Feb 2010 19:02:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/5] tty: Add a function to insert a string of
 characters with the same flag
Message-ID: <20100227190212.5958a7d5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100226221100.GA22352@kroah.com>
References: <20100217130604.16008.86393.stgit@localhost.localdomain>
	<20100226221100.GA22352@kroah.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 14:11:00 -0800
Greg KH <greg@kroah.com> wrote:

> On Wed, Feb 17, 2010 at 01:06:30PM +0000, Alan Cox wrote:
> > The USB drivers often want to insert a series of bytes all with the same
> > flag set - provide a helper for this case.

Thats the original set of patches I sent you - there was a second set
which cleaned up the stuff which leaked from one patch to the next or did
those vanish into the department of email oblivion somewhere ?

Will take a look at it when I get some time and see whats up.

Alan
