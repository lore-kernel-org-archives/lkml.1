Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXEUWzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXEUWzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXEUWzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:55:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:55068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXEUWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=byMgPZgpan1Dixgov4j/X8Vw5Rn/uNjlGs5FYSFlIzarnHS7HkhW7QGUq7OuRa2Vzh+fi1jegGoU8M3uPfV5mxuivMUPQs+qgpgA+CR28gn5w79gXpi3yV1Jjo4qpLMGtbbPJYRyFtMFEdDFZYkPG1frkLPkOhb+t/ucljKSzKU=
Message-ID: <2c0942db0705211555w70d6bdd0wdf458a3bf13b306d@mail.gmail.com>
Date: Mon, 21 May 2007 15:55:01 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Subject: Re: Kernel Oops with 2.6.21.1 on an AMD K7 machine
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070521222857.87180@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070521222857.87180@gmx.net>
X-Google-Sender-Auth: 0698ef89c27bf7ba
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> kernel 2.6.21.1 makes my machine Oops about 20 seconds after KDE 3,5 is brought up showing its graphical login (kdm):

Please include the output out of the actual oops message. It has all
sorts of information that will help track this down.

The "REPORTING-BUGS" file in the root of the kernel source directory
has an example format that covers the sorts of stuff that they want to
see.

Thanks,

Ray
