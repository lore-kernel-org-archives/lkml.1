Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYAJXlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYAJXlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYAJXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:41:03 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:60700 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYAJXlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HR5xUQzL585cLkj7GFrFPFQLtqQ9OCYgY9Swv6xZY+obOv7O+s+MM5kZisZZ/gInjXzsuLFDBMX26Boi4tihAwHLmpXI4VWBtulCp3uFBo054b8SasKyeg4zbGe9pYkYHhb5CHm2Ifca4CfpQ3iHqgRaYQLGlHguF8+bwbhwl3I=
Message-ID: <4d8e3fd30801101540l264068f1i2475f53d6ea11f70@mail.gmail.com>
Date: Fri, 11 Jan 2008 00:40:58 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [x86] list of style offenders
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1200006481.29897.48.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
	 <1200006481.29897.48.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 12:08 AM, Daniel Walker <dwalker@mvista.com> wrote:

> The git logs also show that arch/x86/math-emu/fpu_trig.c hasn't been
> modified since it was pull in on Oct. 11 ..

Daniel,
are we looking at the same tree?
fpu_trig.c has been modified (and cleaned up) by Ingo 35 hours ago:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=history;f=arch/x86/math-emu/fpu_trig.c;h=ecd06680581c51cbb7631cd0240708e92d9ef919;hb=mm

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
