Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZCAPev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZCAPev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbZCAPen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:34:43 -0500
Received: from mail001.aei.ca ([206.123.6.130]:36367 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbZCAPem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:34:42 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Mar 2009 10:34:41 EST
From: Ed Tomlinson <edt@aei.ca>
To: Peter Feuerer <peter@piie.net>
Subject: Re: [PATCH] acerhdf: Acer Aspire One fan control
Date: Sun, 1 Mar 2009 10:27:21 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.28.7-rc1-crc-00285-g1aa936f; KDE/4.2.0; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
References: <cone.1234471033.988571.5384.1000@mentalhome> <1235763653.24506.6.camel@localhost> <cone.1235847508.919525.5537.1000@onepiie>
In-Reply-To: <cone.1235847508.919525.5537.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903011027.21779.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009 13:58:28 Peter Feuerer wrote:
> Hi Joe, Hi List,
>
> thank you very much for your tips!
>
> Joe Perches writes:
> > On Fri, 2009-02-27 at 19:58 +0100, Peter Feuerer wrote:
> >> What do you think about this piece of code?
> >
> > I think you should run it through lindent/checkpatch.
>
> I let the checkpatch.pl script ran over the code and corrected every single
> warning and error. The resulting code is at the end of this email.
>
> Do you (or anyobdy else on this list) have any further tips, suggestions or
> advices? If everybody is fine with the code, what will be the next steps?
>
> kind regards,
> --peter

It this now in a state that it makes sense to put it in linux next?  or should 
mm be the target?

I would like to see this in the kernel.  It is being used.  My wife's acer is 
runing a version it.  I suspect she is far from alone.

TIA
Ed Tomlinson
