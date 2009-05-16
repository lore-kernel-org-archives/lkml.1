Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbZEPD2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbZEPD2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 23:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbZEPD2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 23:28:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:65095 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZEPD2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 23:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gC1a21F0SXzoAfJ5kHbHxaJLM63+rYKZ+suxJDmt0i7yIWmuQ+823qS1o/D+rjnqk9
         hzHT8J4/WDcaTh8WMFYjBz9xYadms8J2kK/3xiP3KAt2Nx6P8lLbaEjsra1oxcacHeux
         tCHhvw5jLzWi22xB5e6JfD7Xsp8dz1dThGnTQ=
Date: Fri, 15 May 2009 20:27:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090516032754.GC12099@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org> <20090513191953.GA10629@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513191953.GA10629@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 08:19:53PM +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> > On Tue, May 12, 2009 at 08:20:54PM -0700, Dmitry Torokhov wrote:
> > > 
> > > Could you try booting with i8042.debug and send me dmesg of the case
> 
> See below:
> 

Thanks. I have an idea what is happening... Could you please attach the
debug patch below and give me debug dmesg of the failure again? Thanks!

-- 
Dmitry
