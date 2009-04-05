Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZDENbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZDENbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 09:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZDENau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 09:30:50 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:65355 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbZDENat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 09:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=x6mue37VCPSfrjvHJ+lVU8GHbyvZokpYbQ28yg2GgnXDhhvWaRqey0LqQTZkoFokR5
         ehJNXMA3l9OELVizOPE82bKrqPkWv6KU7pFpxCmsKGA9BGKLGmOmqIaKncgPmwdRqWhw
         fXObbBaD/88rHb9uHXcpDlCIBGbQvqw9Tg7Lk=
Date: Sun, 5 Apr 2009 15:30:41 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Bryan Henderson <hbryan@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Replacing VFAT as filesystem on removeable media
Message-ID: <20090405153041.08238acf@varda>
In-Reply-To: <49D8510A.3010606@zytor.com>
References: <OFF614A035.0DA52102-ON8825758C.00613C94-8825758C.006215D5@us.ibm.com>
	<200904031029.03581.Martin@lichtvoll.de>
	<49D8510A.3010606@zytor.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 04 Apr 2009 23:34:50 -0700
"H. Peter Anvin" <hpa@zytor.com> escribió:

> Martin Steigerwald wrote:
> >>
> >> How do you mean "replace"?
> >>
> >> VFAT's standardness today comes from the fact that virtually every
> >> personal computer in the world today and for the foreseeable future is
> >> able to read and write VFAT.  Do you envision some other filesystem
> >> format achieving that status?
> > 
> > That was my (possibly crazy) idea yes. ;)
> > 
> 
> Ironically enough, one of the better filesystems for being supported by
> many OSes is probably ext2.  However, that doesn't mean it is even in
> the same rough ballpark as (V)FAT.

  What about UDF ?
> 
> 	-hpa
> 
