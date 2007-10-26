Return-Path: <linux-kernel-owner+w=401wt.eu-S1765090AbXJZQo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765090AbXJZQo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXJZQos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:44:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:16107 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbXJZQor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N4cUQXxvI7a289Nu3Hjc4cPe1RvUAlZwltyAOf0vEVc0jo+DiIqcvnmdZEbOfaUSc5p4yuOnSnQQVYyWxkClXOTr4q745L1KyGnoe1rBrvzapdypEsOoAkImVTh7iuBIN6j43dhQK5ciUSZLiye1lv0b448yZsRIGERGbxc71ic=
Message-ID: <e9c3a7c20710260944j620d6867k6f7a8e8dc5f1909@mail.gmail.com>
Date: Fri, 26 Oct 2007 09:44:44 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20071024201616.02f87b20@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	 <e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	 <20071024201616.02f87b20@siona>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > Otherwise, Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> Thanks. Are one of you going to pick it up as well?
>

Yeah, I'll pick it up.  I'll leave off the AVR addition to DMADEVICES
because I assume it will come with the future patch implementing the
driver, no?

> Håvard

Thanks,
Dan
