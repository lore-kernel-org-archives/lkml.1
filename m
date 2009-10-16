Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZJPSFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZJPSFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZJPSFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:05:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZJPSFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:05:35 -0400
Date: Fri, 16 Oct 2009 11:03:43 -0700
From: Greg KH <gregkh@suse.de>
To: Massimo Cetra <mcetra@navynet.it>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [00/46] 2.6.31.5-stable review
Message-ID: <20091016180343.GA16808@suse.de>
References: <20091016171422.GA13339@kroah.com> <4AD8B41F.2070702@navynet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD8B41F.2070702@navynet.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 07:57:51PM +0200, Massimo Cetra wrote:
> Greg KH ha scritto:
>> This is the start of the stable review cycle for the 2.6.31.5 release.
>> There are 46 patches in this series, all will be posted as a response to
>> this one.  If anyone has any issues with these being applied, please let
>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>> to add a Signed-off-by: line to the patch, please respond with it.
>>
>>   
> Please consider adding this:
> http://lkml.org/lkml/2009/10/13/154
>
> and this:
> http://lkml.org/lkml/2009/10/14/430
>
> which definitely makes 2.6.31 unusable for virtualization with KVM and with 
> some block devices not supporting barriers.

Do you have git commit ids for these fixes?

thanks,

greg k-h
