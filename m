Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbXFGLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbXFGLqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXFGLqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:46:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4256 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbXFGLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:46:11 -0400
Message-ID: <4667F00A.106@shadowen.org>
Date: Thu, 07 Jun 2007 12:46:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>
In-Reply-To: <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 04/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
>>
>> This version brings a host of changes to cure false positives and
>> bugs detected on patches submitted to lkml and -mm.  It also brings
>> a number of new tests in response to reviews, of particular note:
>>
> A  chmod +x scripts/checkpatch.pl  would be nice :)

While git carries the permissions I am am pretty sure a straight patch
doesn't.  Where did you pick up your copy from linus' tree or from the
-mm one?

-apw

