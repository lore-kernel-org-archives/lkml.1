Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXFNRBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXFNRBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXFNRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:01:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:3649 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXFNRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GC/If3XAN10Ud2OFbdC9CzN7b12JAB0XVL2AYiOBrvtgEAksCYrakjjCnsyrGNu6gD+eC1FvDq6XqlFMIo2CHs56wcFQiG+N/MrwtlcQbm+zB20PQ2WrvLB0Ane1QlJUbzSSmjaVyJnhC3mJMc3fnrDnzeTBOQ+POASeze6oweA=
Message-ID: <d120d5000706141001o2d00f20cqb4133bf7b9ba11ab@mail.gmail.com>
Date: Thu, 14 Jun 2007 13:01:20 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Bernd Paysan" <bernd.paysan@gmx.de>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070614164124.GP21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <200706141023.21624.bernd.paysan@gmx.de>
	 <20070614153935.GO21478@ftp.linux.org.uk>
	 <200706141832.58526.bernd.paysan@gmx.de>
	 <20070614164124.GP21478@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Thu, Jun 14, 2007 at 06:32:57PM +0200, Bernd Paysan wrote:
>
> > BTW: If I grep through Linux, I find two files where you have noted your
> > copyright and the release conditions (GPL v2), and I think last time I did
> > the same thing, I found two GPLv2-files, as well - all other files with "Al
> > Viro" in it apparently have multiple authors. These two files may be the
> > same ones, or maybe there are two other files, making it four in total (or
> > some further I missed, the text of v2 only is not as normed as the text
> > for "v2 or later", but in general it's rare). These files clearly have to
> > be rewritten or premission has to be asked when updating COPYING to GPLv3.
> > But that's not a show-stopper.
>
> Rot.  "Multiple authors" doesn't get you out of that.  If you take a code
> available under GPLv2 or later and combine it with code under specific
> version of GPL, result is under than specific version of GPL.  If you want
> to argue against that, make sure to Cc RMS on that, I would really like to
> hear his opinion.
>
> Multiple authors == need permission from each author with enough
> contributions to that file to make the contributions in question
> copyrightable.
>
> And in my case (and case of gregkh, and...) that would be considerably
> more than a couple of files.  Really.

I would expect that if you contribute to a file that explicitely says
"GPL v2 or later" and you do not change that wording then you agree
GPL v2 or later for that particular contribution. So for example
drivers/net/plip.c could be changed to GPL v3 even though you
contributed to it.

-- 
Dmitry
