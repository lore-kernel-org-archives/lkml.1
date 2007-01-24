Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbXAXWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbXAXWwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932856AbXAXWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:52:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:3414 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932860AbXAXWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:52:33 -0500
Date: Wed, 24 Jan 2007 23:52:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>, len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
Message-ID: <20070124225238.GT17836@stusta.de>
References: <200701242346.44673.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200701242346.44673.pluto@agmk.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 11:46:44PM +0100, Paweł Sikora wrote:

> hi,

Hi Paweł,

> for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
> http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
> disabling the "amd-k8 cool'n'quiet" option in bios helps.
> moreover, it works fine for 2.6.17.13, so it looks like
> a recent regression. i can provide more details if you need.

thanks for your report.

Can you narrow down a bit when it started?
Is 2.6.19 OK?
Is 2.6.18 OK?

I've Cc'ed the ACPI maintainers that might have some clues.

> BR,
> pawel.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

