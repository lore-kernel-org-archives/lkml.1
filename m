Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbXJ0QJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbXJ0QJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXJ0QJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:09:24 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:50941 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752819AbXJ0QJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:09:23 -0400
Date: Sat, 27 Oct 2007 18:07:16 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@gmail.com>
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Message-ID: <20071027180716.4e9c3786@siona>
In-Reply-To: <e9c3a7c20710260944j620d6867k6f7a8e8dc5f1909@mail.gmail.com>
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	<20071024201616.02f87b20@siona>
	<e9c3a7c20710260944j620d6867k6f7a8e8dc5f1909@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 09:44:44 -0700
"Dan Williams" <dan.j.williams@gmail.com> wrote:

> On 10/24/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > > Otherwise, Acked-by: Dan Williams <dan.j.williams@intel.com>  
> >
> > Thanks. Are one of you going to pick it up as well?
> >  
> 
> Yeah, I'll pick it up.  I'll leave off the AVR addition to DMADEVICES
> because I assume it will come with the future patch implementing the
> driver, no?

Sure, either way is fine with me.

Thanks,
Håvard
