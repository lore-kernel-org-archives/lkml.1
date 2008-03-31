Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYCaPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYCaPaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYCaPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:30:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:17841 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYCaPaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iQb3mHYdH3iHhO17NfA7R967PVr4H1vJTjYHsWJA+/+wKIPKliPNr4l1qldfzJPM0Zg9Ni/86rg5vwT+eAiMr107cW9UXN5FXzui1Dw/ayvlQNFblFYS7D5+j00qSObbn6/ca4OaXyeLuhq2WoK+aK/qZ+D7oMMXgOI7xYwOWI8=
Message-ID: <804dabb00803310830g55552d58gb739a6275dc530ee@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:30:16 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Mulyadi Santosa" <mulyadi.santosa@gmail.com>
Subject: Re: blktrace debugging: how to use it
Cc: linux-kernel@vger.kernel.org,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
In-Reply-To: <f284c33d0803302141x298d3785xcebabd28be65c0d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0418C.8080407@gmail.com>
	 <f284c33d0803302141x298d3785xcebabd28be65c0d0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 12:41 PM, Mulyadi Santosa
<mulyadi.santosa@gmail.com> wrote:
> Hi..
>  All I remember, the user space code is available from Jens Axboe's CVS
>  or http://www.kernel.org/pub/linux/kernel/people/axboe/tools/blktrace.c
>
Thanks Mulyadi Santosa, the link I found was:

http://www.kernel.org/pub/linux/kernel/people/axboe/tools/old/blktrace.c

(Jens may have change it immediately u sent out the email :-)).

-- 
Regards,
Peter Teoh
