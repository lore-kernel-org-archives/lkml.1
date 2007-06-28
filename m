Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXF1TQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXF1TQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 15:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763913AbXF1TQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 15:16:46 -0400
Received: from web52508.mail.re2.yahoo.com ([206.190.48.191]:24323 "HELO
	web52508.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762319AbXF1TQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 15:16:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=y++sgl00mkbRW3lb1PfsHzEX87+eoPByf+DA5Jy82a0N/BQ37xo/OINhx1hxua18Z16GsoHnzdtz0Z72QbRHX6bt+DPDeMr0GILYuAYwub4O8yITl0OJZ1zUCuKpGsXwi+l1lWFGKWrp4Mjd7nUeJNwfjhwGSlO21vq2xLRQlKo=;
X-YMail-OSG: gx16TwMVM1lraIP0Jq8kt3Mkhjr37cwIMNN8zAAy1LOmhDoRcncPvEXkIVWvT3qzlCLK5uks0l_akM22TJHu93mg3gkfSZ_rq4Sd
Date: Thu, 28 Jun 2007 12:16:44 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
To: Carlo Wood <carlo@alinoe.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070627212407.GA26615@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <524743.6171.qm@web52508.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Carlo Wood <carlo@alinoe.com> wrote:

> Or use the same hardware as me (and debian)-- and
> read on my home page how
> I got things working :p
> 
> hikaru:/usr/lib>dpkg -l | grep nvidia
> ii  nvidia-glx									 100.14.11-0          NVIDIA
> binary Xorg driver
> ii  nvidia-glx-dev								 100.14.11-0         
> NVIDIA binary Xorg driver development files
> ii  nvidia-kernel-2.6-amd64							 100.14.11+beta   
>    NVIDIA binary kernel module for 2.6 series c
> ii  nvidia-kernel-2.6.18-4-amd64						
> 100.14.11+beta       NVIDIA binary kernel module for
> Linux 2.6.18
> ii 
>
nvidia-kernel-2.6.22-rc5-agp1-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64
> 100.14.11+beta       NVIDIA binary kernel module for
> Linux 2.6.22
> 
> -- 
> Carlo Wood <carlo@alinoe.com>
> 
> PS I use two of my Samsung SyncMaster 205BW
> (1650x1050) as dual head
>    on an ASUS EN8600 GTS (dual-head). You need
> nvidia's beta drivers
>    (>= 100.14.06) for that to work though.
> 
> 

Yes - I downloaded the drivers from nVidia and
everything works now. Thanks to everyone for your
help.




       
____________________________________________________________________________________
Choose the right car based on your needs.  Check out Yahoo! Autos new Car Finder tool.
http://autos.yahoo.com/carfinder/
