Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbXFCGXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbXFCGXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXFCGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:23:44 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55356 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXFCGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:23:43 -0400
Date: Sun, 03 Jun 2007 00:23:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-reply-to: <fa.vxJKq726YMWJY2i/waKQsNec3aU@ifi.uio.no>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Message-id: <46625E74.8070800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.eE9c0s9eXX/aO2N8hiu3e2Yehz8@ifi.uio.no>
 <fa.hq4JzIoUe01l8ywIZPkqjocRBmc@ifi.uio.no>
 <fa.3aN+T/xQVA3sf9DdMPLOfUVmYA0@ifi.uio.no>
 <fa.mJ71j4nyi6ALIkQjLcpIJtTbVVI@ifi.uio.no>
 <fa.vxJKq726YMWJY2i/waKQsNec3aU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Sent this in another e-mail to LKML, it breaks support for my UPS:
> 
>  From jpiszcz@lucidpixels.com Sat Jun  2 18:43:52 2007
> Date: Sat, 2 Jun 2007 18:43:52 -0400 (EDT)
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: linux-kernel@vger.kernel.org
> Subject: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor 
> (error sending control message: Operation not permitted)
> 
> I use nut-2.0.4-4 with a UPS attached via USB and from 2.6.21.3 -> 
> 2.6.22-rc3 it
> stops working, see below.  My .config is attached.
> 

I also have seen this on -rc2-mm1, my APC UPS status was not showing up. 
  I haven't investigated in any more detail.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

