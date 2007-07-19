Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXGSSgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXGSSgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXGSSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:35:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:13574 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbXGSSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RTW3ATiDaO++3H/vqskvlKhN99cc5P655/NeFVGsbd2yweGlVhdicJhhbNSvDZK1Ek7wrdqoQysXLGQ8dFApghqdpBNB8Y4nzlxpb2/zTeukdbFocdbptoAcmslRUAjsvHtlB1COh4aIGsj1XczTQ4CgA85jQ9ai1UdgxEM+BZI=
Message-ID: <6bffcb0e0707191135s2d3d06aep71f42613a4385a09@mail.gmail.com>
Date: Thu, 19 Jul 2007 20:35:47 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [2/2] 2.6.22-git: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Theodore Tso" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       "Mingming Cao" <cmm@us.ibm.com>, "Doug Chapman" <doug.chapman@hp.com>,
       "Vasily Tarasov" <vtaras@openvz.org>, linux-ide@vger.kernel.org,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Kumar Gala" <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       "Christoph Lameter" <clameter@sgi.com>, "Andi Kleen" <ak@suse.de>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jean Delvare" <khali@linux-fr.org>, "Tejun Heo" <htejun@gmail.com>
In-Reply-To: <a781481a0707191007q241f5f5bh6c029da56090d8b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469F9125.8040502@googlemail.com> <469F92AF.10405@googlemail.com>
	 <a781481a0707191007q241f5f5bh6c029da56090d8b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > Subject         : ext4 build warnings
> > References      : http://lkml.org/lkml/2007/7/18/420
> > Last known good : ?
> > Submitter       : Jeff Garzik <jeff@garzik.org>
> > Caused-By       : ?
> > Handled-By      : Mingming Cao <cmm@us.ibm.com>
> > Status          : unknown
>
> Mingming Cao fixed this:
>
> http://lkml.org/lkml/2007/7/18/564
>
> Dunno if it's in latest git
>

Informations updated. Thanks!

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
