Return-Path: <linux-kernel-owner+w=401wt.eu-S933070AbXBVOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbXBVOeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXBVOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:34:18 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45228 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbXBVOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:34:17 -0500
Date: Thu, 22 Feb 2007 08:34:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-reply-to: <fa.FUWb3SroQ9sotSIAakSnOjAJ6Ks@ifi.uio.no>
To: Francesco Pretto <ceztko@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45DDA9E6.4010408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.3exEXR8lVInBQnVOUQZm+V7aqZE@ifi.uio.no>
 <fa.SUiPva6BdeZMJsAbFE/HC5i0jfs@ifi.uio.no>
 <fa.YdL5PeKPp7ARbGWGIgctXVh/iLQ@ifi.uio.no>
 <fa.xsAgWkCiu+x5MGhvd/b5EHrU+ic@ifi.uio.no>
 <fa.FUWb3SroQ9sotSIAakSnOjAJ6Ks@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> Yes, windows XP could handle better the power button pressed event
> (causing the hd not to go to emergency parking, even when forced
> shut-down, most of the times). But regarding a normal shut-down cycle,
> isn't this a regression? You don't solve a regression adding a feature
> (IMHO).

It's a feature that's in drivers/ide (I believe) but isn't in libata or 
the SCSI layer.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

