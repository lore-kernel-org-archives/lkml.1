Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZJBXq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZJBXq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZJBXq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:46:26 -0400
Received: from kroah.org ([198.145.64.141]:38527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbZJBXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:46:24 -0400
Date: Fri, 2 Oct 2009 15:09:03 -0700
From: Greg KH <greg@kroah.com>
To: Bruce Jones <brucej97223@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, wfp5@virginia.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: comedi: cleanup formating in
 drivers/8255.c
Message-ID: <20091002220902.GB32440@kroah.com>
References: <4ABD9995.7090600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABD9995.7090600@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 09:33:25PM -0700, Bruce Jones wrote:
> Fix the formatting in this driver to conform to the
> standard.  Move EXPORT_SYMBOL to under the exported
> funtion, and add KERN_INFO to some diagnostic printks.

Same rejection problem here, someone beat you to it.

sorry,

greg k-h
