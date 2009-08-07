Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZHGNtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZHGNtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbZHGNtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:49:39 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63278 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZHGNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pP9jpxUSKOF4MBrPiH41WQMLTnXF4NHPi/fGkC/vMz1HiSF+nbwHt/mghFsxI77YwP
         7BY6BX8BIdWhffC4+FHR8ID9GV4+5ThlVnsR8o2en9wD0UWtvZmSUW4KW+5XBdDntfyx
         s/lcS1gTSmr0f8eeFHbulUsEk+R/haY50TnAo=
MIME-Version: 1.0
In-Reply-To: <20090807134659.GA2093@darkstar>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	 <20090807134659.GA2093@darkstar>
Date: Fri, 7 Aug 2009 21:49:36 +0800
Message-ID: <a8e1da0908070649j2d328843u50b07db522b69e46@mail.gmail.com>
Subject: Re: mmotm 2009-08-06-00-30 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 9:47 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
> Hi, andrew
>
> Booting with this release, init (maybe getty?) reports something like:
>
> INIT: open /dev/console failed with input/output error
>
> 2.6.31-rc5 is fine.
>
> Any hints to find the root problem?
>
> Another problem:
>
> When I moving mouse or pressing key the screen will become black, then restore the normal screen.

Forgot to tell, it happens after x.org start

>
> --
> Regards
> dave
>



-- 
Regards
dave
