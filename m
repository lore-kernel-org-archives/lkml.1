Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZHZFeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZHZFeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZHZFen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:34:43 -0400
Received: from kroah.org ([198.145.64.141]:36076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394AbZHZFem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:34:42 -0400
Date: Tue, 25 Aug 2009 22:26:47 -0700
From: Greg KH <greg@kroah.com>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-usb@vger.kernel.org, gustavo@padovan.org, smurf@smurf.noris.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: remove unused variable
Message-ID: <20090826052647.GB18777@kroah.com>
References: <1251068150-15001-1-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251068150-15001-1-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 07:55:50PM -0300, Gustavo F. Padovan wrote:
> struct usb_serial *serial is not used.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>

What kernel version is this patch against?  I think this is already
fixed in linux-next, right?

thanks,

greg k-h
