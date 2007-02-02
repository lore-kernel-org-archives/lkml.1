Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbXBBKsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbXBBKsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXBBKsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:48:11 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:36965 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751936AbXBBKsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:48:09 -0500
Message-ID: <45C3164C.1050805@aitel.hist.no>
Date: Fri, 02 Feb 2007 11:45:32 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: davids@webmaster.com
CC: sofar@foo-projects.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <MDEHLPKNGKAHNMBLJOLKOEBOBFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEBOBFAC.davids@webmaster.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
> In any event, even if you assume it is a copyright enforcement scheme, it is
> not circumvention to remove or disable such a scheme with the permission of
> the copyright holder. Section 2 of the GPL grants just such permission.
>   

The way I see this:
There is a copyright enforcement scheme.  (A simple test for
the word GPL.) Trivial, but still an enforcement scheme.

You are of course allowed to remove the test completely,
as the GPL lets you change the kernel source in any way you wish.

But you are still not allowed to circumvent the scheme as long as
it is in place - in those parts of the world were circumventing is
illegal.

So a vendor using the \0 trick is on very shaky ground. 
He has another option - to patch out the test.  But he
don't want that, for then he have to distribute a kernel,
not only a module.

Helge Hafting
