Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0CAQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:57:19 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54723 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844Ab0CAQ5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:57:18 -0500
Date: Mon, 1 Mar 2010 17:56:39 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stewart Robertson <stewart_r@aliencamel.com>
Cc: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, keil@b1-systems.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: patch Staging-comedi-fix-coding-style-issues.patch
Message-ID: <20100301165639.GB26368@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stewart Robertson <stewart_r@aliencamel.com>,
	Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, keil@b1-systems.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <4B88F5ED.9040405@aliencamel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B88F5ED.9040405@aliencamel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Feb 27, 2010 at 10:37:33AM +0000, Stewart Robertson wrote:
> From: Stewart Robertson <str@minty7.(none)>

Could you use a proper email-address here, please?

> Date: Sat, 27 Feb 2010 10:03:27 +0000
> Subject: [PATCH] Staging: comedi: fix coding style issues
> This is a patch to the ni_daq_dio24.c file that fixes line
> over 80 characters and KERN_INFO issues found by checkpatch.pl
> Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

Please add a few spare blank lines between the Subject and the message, and
between the latter and the SoB-line.

Thanks!

	Dominik
