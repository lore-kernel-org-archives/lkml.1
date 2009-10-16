Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbZJPR5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbZJPR5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZJPR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:57:55 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:58439
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZJPR5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:57:54 -0400
Message-ID: <4AD8B41F.2070702@navynet.it>
Date: Fri, 16 Oct 2009 19:57:51 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/46] 2.6.31.5-stable review
References: <20091016171422.GA13339@kroah.com>
In-Reply-To: <20091016171422.GA13339@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH ha scritto:
> This is the start of the stable review cycle for the 2.6.31.5 release.
> There are 46 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
>   
Please consider adding this:
 http://lkml.org/lkml/2009/10/13/154

and this:
 http://lkml.org/lkml/2009/10/14/430

which definitely makes 2.6.31 unusable for virtualization with KVM and 
with some block devices not supporting barriers.

Max

