Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbXAYAfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbXAYAfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbXAYAfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:35:00 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:50420 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXAYAe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:34:59 -0500
Date: Wed, 24 Jan 2007 18:33:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA hotplug from the user side ?
In-reply-to: <fa.DH50RMz6OHKG0AoGA/cChsCW8Ig@ifi.uio.no>
To: Soeren Sonnenburg <kernel@nn7.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Message-id: <45B7FAD5.6030506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.pn1gmGiSlhDVMiPyzEEm1A66vcY@ifi.uio.no>
 <fa.Od11QHN89ZQ9VkFktF6HvxWuLV0@ifi.uio.no>
 <fa.vsuV8EVipw4cXaHgzWpaf0q1pAA@ifi.uio.no>
 <fa.8a1kVu4a2ISeaFZcL3migbjZ5N0@ifi.uio.no>
 <fa.79JzgEcD2u5B9SYqrw3sr5b+iy8@ifi.uio.no>
 <fa.DH50RMz6OHKG0AoGA/cChsCW8Ig@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> • Note that it might not be such a good idea to do the above on drivers
> which don't implement the new EH yet. Those are as of January 2007:
> sata_nv, sata_promise (getting there) and sata_sx4.

That should be sata_mv not sata_nv.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

