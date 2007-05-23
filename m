Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbXEWHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbXEWHiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXEWHir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:38:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:57408 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXEWHiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EfNgCPTDl8YoXJyhG7z81FFwNVm3CCmwSsI+D20WiHBHywLhEMbnSQcdRS/c/TQOp4jtahFlYcLlSn88Teeo+/2qVUiKQEa6AAq5b3XRyM1PXHYy5zuDRXyx9l34YmSQ9te9DywDHCBKQdoDOS3pAwtkge/EIhtZQOZVay755X8=
Subject: Re: [patch 00/69] -stable review
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070523091903.0ba29bc1@localhost>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1179904140.7043.10.camel@localhost>  <20070523091903.0ba29bc1@localhost>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:38:35 +0200
Message-Id: <1179905915.7043.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 09:19 +0200, Paolo Ornati wrote:
> On Wed, 23 May 2007 09:09:00 +0200
> Romano Giannetti <romano.giannetti@gmail.com> wrote:
> 
> > Will try to reboot with clocksource=acpi_pm, althoughI think that this
> > is the one I'm using. 
> 
> you can see that with:
> 
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> 

Hmmm:

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
acpi_pm 

So I am using it. 

Thanks


