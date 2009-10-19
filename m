Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZJSVzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZJSVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbZJSVzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:55:04 -0400
Received: from kroah.org ([198.145.64.141]:54814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbZJSVzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:55:03 -0400
Date: Mon, 19 Oct 2009 13:50:20 -0700
From: Greg KH <greg@kroah.com>
To: Bruce Beare <bbeare1@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup: indent/format errors, printk calls.
Message-ID: <20091019205020.GA6572@kroah.com>
References: <1255119739-566-1-git-send-email-bbeare1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255119739-566-1-git-send-email-bbeare1@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 01:22:19PM -0700, Bruce Beare wrote:
> ---
>  drivers/staging/comedi/drivers/pcmad.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)

Care to resend this with a bit of description in the body of the patch
that says what it does, as well as a Signed-off-by: line?

thanks,

greg k-h
