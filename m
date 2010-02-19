Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0BSOQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:16:40 -0500
Received: from tex.lwn.net ([70.33.254.29]:33859 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0BSOQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:16:38 -0500
Date: Fri, 19 Feb 2010 07:16:36 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: "masa-korg" <masa-korg@dsn.okisemi.com>
Cc: <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
       <joel.clark@intel.com>
Subject: Re: [PATCH]Add new device drivers for Topcliff
Message-ID: <20100219071636.7d9c2ccd@bike.lwn.net>
In-Reply-To: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com>
References: <000a01cab118$8bbc8600$66f8800a@maildom.okisemi.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010 13:03:44 +0900
"masa-korg" <masa-korg@dsn.okisemi.com> wrote:

> I developed the device drivers for Linux.
> 
> Please refer to our WEB site in Sourceforge.net.
> http://sourceforge.net/projects/generalembedded/files/
> "All Files" -> "Downloads" -> "Beta2"

Thanks for making your drivers available.

However, if you would like to get these drivers reviewed and eventually
merged, it would be good to follow the usual process.  Lots of
information can be found in the kernel documentation directory:

	Documentation/SubmittingPatches
	Documentation/development-process/

In short: you'll want to post your code as patches to the mailing
list(s) so that others can have a look and make comments.

Thanks,

jon


Jonathan Corbet / LWN.net / corbet@lwn.net
