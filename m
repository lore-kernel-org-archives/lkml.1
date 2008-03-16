Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYCPCvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYCPCvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 22:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYCPCvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 22:51:16 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:54154 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYCPCvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 22:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g7o/hT5d2DUb4zm+mUries+KeoI5NY8j7p/8aKw2S6LXZy/dBJ3rByG6Cefb1EZODlLVsXbnJi7fYsCCZ+E86tZ/jVdcPMJhQDzMLlMTCKZHJht2M2aCm6UzFvSmrpQlf74yRlDAT6AyJC50Y6DZ3TDw2vkHwlhPPqyLYhEpAww=
Message-ID: <c384c5ea0803151951g47bd5214j18334f03f95821fe@mail.gmail.com>
Date: Sun, 16 Mar 2008 03:51:10 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: Linux UIO driver cache problem in PowerPC (fix)
Cc: "Jean-Samuel Chenard" <jsamch@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       grant.likely@secretlab.ca,
       "Juergen Beisert" <juergen127@kreuzholzen.de>
In-Reply-To: <20080314113336.63af1e7a@bluebox.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <169c03cb0803121222h5fca9cdal5af873cd2a700f4d@mail.gmail.com>
	 <20080313081932.4edee290@dilbert.local>
	 <20080314113336.63af1e7a@bluebox.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 14, 2008 at 11:33 AM, Hans J. Koch <hjk@linutronix.de> wrote:
>  I investigated a bit and found your patch to be correct. I cleaned it
>  up a bit and sent it to Greg and LKML. I added you as author and also
>  took the freedom to add your Signed-off-by.
>
Could you elaborate why exactly this is needed, maybe even as a
comment in the patch?

It seemed non-trivial enough to rectify adding a comment.

Thanks,
-- 
Leon
