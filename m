Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbXFNRQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbXFNRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXFNRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:16:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:12903 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXFNRQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AhvY+u0vlDjiuQZQiEEpZIjTP8qduGuZa4JxVhe5hERvIhYsxyRB1mIbH9zFXJk1EjaUUkKe63dGmfaTCnCFlwAWX6NL2OkSy64tmlMy/PiCRzHCpAZFe4GyIZK7K8l8pjE0C8pmbh2MkPhDh3mdrqIMu8CUuCVxgEAUgvKH25c=
Message-ID: <d120d5000706141016u4893c1fbp2241f847b8e1e29d@mail.gmail.com>
Date: Thu, 14 Jun 2007 13:16:01 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Bernd Paysan" <bernd.paysan@gmx.de>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070614170902.GQ21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <200706141023.21624.bernd.paysan@gmx.de>
	 <20070614153935.GO21478@ftp.linux.org.uk>
	 <200706141832.58526.bernd.paysan@gmx.de>
	 <20070614164124.GP21478@ftp.linux.org.uk>
	 <d120d5000706141001o2d00f20cqb4133bf7b9ba11ab@mail.gmail.com>
	 <20070614170902.GQ21478@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Thu, Jun 14, 2007 at 01:01:20PM -0400, Dmitry Torokhov wrote:
> > >Multiple authors == need permission from each author with enough
> > >contributions to that file to make the contributions in question
> > >copyrightable.
> > >
> > >And in my case (and case of gregkh, and...) that would be considerably
> > >more than a couple of files.  Really.
> >
> > I would expect that if you contribute to a file that explicitely says
> > "GPL v2 or later" and you do not change that wording then you agree
> > GPL v2 or later for that particular contribution. So for example
> > drivers/net/plip.c could be changed to GPL v3 even though you
> > contributed to it.
>
> After you exclude such cases it's still more than a couple of files...
>

Undoubtedly. I was just responding to neet to contact multiple authors point.

-- 
Dmitry
