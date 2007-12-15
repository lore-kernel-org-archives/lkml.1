Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbXLOSRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbXLOSRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXLOSR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:17:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:43384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbXLOSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:17:27 -0500
Date: Sat, 15 Dec 2007 10:08:20 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/60] 2.6.23-stable review
Message-ID: <20071215180820.GB7587@suse.de>
References: <20071213065039.GA6867@kroah.com> <4763FC4C.8000809@caiway.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4763FC4C.8000809@caiway.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 05:09:48PM +0100, Jan Evert van Grootheest wrote:
> Greg KH wrote:
>> This is the start of the stable review cycle for the 2.6.23.10 release.
>> There are 60 patches in this series, all will be posted as a response to
>> this one.  If anyone has any issues with these being applied, please let
>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>> to add a Signed-off-by: line to the patch, please respond with it.
>>
>>   
> Hi Greg,
>
> Do you think it might be possible to add the subjects of the patches
> next time in the announcement? This would give people an easy way
> (besides the diffstat) to check what is getting fixed.

The subject of the individual patches are in the email thread that is
attached to this announcement, so it should be quite simple to get this
information by just looking in your mail reader :)

Also, it would be hard to do this, unless someone has a patch to quilt
to provide this kind of information?

thanks,

greg k-h
