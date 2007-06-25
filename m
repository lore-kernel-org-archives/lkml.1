Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbXFYJlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbXFYJlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXFYJlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:41:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:39186 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXFYJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EqZMLHVLJIbU+hCessxpLo6a/u6yJQuNY442soF4W6rg0r2CYB6yu6d9g6DqIsUQATRgimUgW/YFaIE3dE8/NgJL2NyEL+C3q0vITJ08py/hlYlcq/Z1gHPE7aqjIU1c4Az6f4cpK2SydOOyY+5j8pw1yCVuLZdZJD2b0ghQMJM=
Message-ID: <7e63f56c0706250241q19c6cb49yb846a38eb10a53e6@mail.gmail.com>
Date: Mon, 25 Jun 2007 12:41:29 +0300
From: "Robert Iakobashvili" <coroberti@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Scaling Max IP address limitation
Cc: djones@rossove.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706251130320.11964@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467EA7C1.4080006@rossove.com>
	 <20070624110236.fa36b2f9.akpm@linux-foundation.org>
	 <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>
	 <467F063A.2030805@rossove.com>
	 <7e63f56c0706250147w508d3aeay5f7aaca8215953c8@mail.gmail.com>
	 <Pine.LNX.4.64.0706251130320.11964@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 6/25/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jun 25 2007 11:47, Robert Iakobashvili wrote:
> >
> > I am getting after initial successes some errors:
> > "rtnl_talk(): RTNETLINK answers: Cannot allocate memory"
> > and
> > #ip addr | wc-l is 8194.
>
> I'd be surprised if it was 4096 on x86 and 8192 on x86_64...

Missed to mention: the CPU is Pentium-4.


-- 
Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...........................................................
http://curl-loader.sourceforge.net
A web testing and traffic generation tool.
