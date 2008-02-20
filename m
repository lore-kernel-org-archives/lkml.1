Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbYBTRy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbYBTRy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbYBTRys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:54:48 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:46070 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbYBTRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:54:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=yIYefCAPT4OK1i9r5Y/LtAN3gikqwIoqVeg1mrHJ0VNjiioxWFlGIJYLtoum+J1T1+LYgO/Fs1bUv4UOB9AoiCy+m4DDXoTxIz4i40aYGHXCLoJS42hWnwWNAhhWlSaHUtssQYA+DaiwK+crrajCGHHqlAeyPgeJyw97FTXXH9Y=
Message-ID: <b6a2187b0802200954p1cccb01aqbc48c865797f0af1@mail.gmail.com>
Date: Thu, 21 Feb 2008 01:54:45 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21, 2008 1:28 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That said, before you do anything else, try if suspend-to-RAM works.

Linus, guess I missed this part ... so before touch anything, I did
tried suspend-to-ram, and it works on console and in X.

And suspend-to-disk hangs, but I can still press and hold the power
button to power it off. Then upon powering on and resume, I get the
ugly green "console" screen. I can still type and move around.
Starting X runs fine. Ctrl-Alt-Del or switching back to console will
get back to the green screen.

Thanks,
Jeff.
