Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbZBLVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbZBLVu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZBLVus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:50:48 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40209 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbZBLVus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:50:48 -0500
Date: Thu, 12 Feb 2009 21:50:40 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl --file gives wierd warning
Message-ID: <20090212215040.GC6698@shadowen.org>
References: <20090212210532.GA5727@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212210532.GA5727@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 01:05:32PM -0800, Greg KH wrote:
> Hi Andy,
> 
> With Linus's tree I get the following wierd warning when using the
> --file option on checkpatch.pl:
> 	$ ./scripts/checkpatch.pl --file drivers/staging/phison/phison.c
> 	WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch
> 
> I'm guessing that this isn't intentional :)
> 
> Any ideas?

heh yeah, thats fixed in my tree.  I should check the last couple of
days testing and push those.

-apw
