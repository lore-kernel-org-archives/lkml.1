Return-Path: <linux-kernel-owner+w=401wt.eu-S1031321AbXDRDMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031321AbXDRDMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031319AbXDRDMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:12:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:17887 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031321AbXDRDMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XLZncUOPqwRMb9afNbqlWUxprTql+kILDtpNsREOKLJHdZ1MLGMfdNTcEe22VNeoVu25jzJUARcohXM8HSnuFGTwdGxiM/0ZVmXGb2U+MIgyynqTISS4LmHbEVvi+NcXBRB8DQf7OIcLOULR1P/6Y9R6geF0XnVc37oQ/UzTxQI=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: floppy.ko
Date: Tue, 17 Apr 2007 23:12:49 -0400
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Alain.Knaff@poboxes.com
References: <200704170036.00605.gene.heskett@verizon.net> <4624CECD.2070805@zytor.com>
In-Reply-To: <4624CECD.2070805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704172312.49787.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007, H. Peter Anvin wrote:
>Gene Heskett wrote:
>> I have the usual fd0, a 3.5" 1.44 drive, and fd1, a 5.25" 720k drive in
>> this machine, both are enabled in the bios with the correct types being
>> set there.
>
>A 5.25" 720k drive?!  That's not a PC standard drive -- 5.25" came in
>180K, 360K and 1200K varieties, whereas 3.5" came in 720K, 1440K and
>2880K varieties (not including superfloppies.)
>
>	-hpa

It sure is a std drive, Peter, although many of the later ones that were set 
up as 1.2 megger's by the pc crowd who have access to a 500 kilobaud 
controller, could have the 360 rpm spindle jumper'd back to 300 rpm, and when 
fed with a 250 kilobaud controller (WD177x/277x/279x family, which includes 
the Fujitsu MB8877), they are perfect 720k devices and are spec'ed that way 
by the makers.  Many of the older full height Tandon 100-4's could also step 
quite a few tracks closer to the spindle & I ran them as 765k drives by using 
84 tracks.  I even have a chinon that will make 86 tracks most of the time.

These were all quite common in the middle '80's.  Before your time I suspect.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I have the simplest tastes.  I am always satisfied with the best.
		-- Oscar Wilde
