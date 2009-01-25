Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbZAYUT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbZAYUT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZAYUTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:19:49 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:35992 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZAYUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:19:48 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=GSFlAo79l1Qmjo3mdGIA:9 a=iihfJz0NJMUCMUa0GAcBt0igwg0A:4
Message-ID: <497CC962.7060900@shaw.ca>
Date: Sun, 25 Jan 2009 14:19:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Charles Landau <clandau@macslab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Gateway DX4720-03 apic problem
References: <497CBF12.10202@macslab.com>
In-Reply-To: <497CBF12.10202@macslab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Landau wrote:
> I have a new Gateway DX4720-03 PC and have discovered that it won't 
> install Fedora 10 unless I give the kernel boot option "noapic" or 
> "nolapic".
> 
> This system's processor is the Intel Pentium Dual Core E5200.
> 
> It would seem that this is either a kernel bug to be fixed, or a 
> documentation bug so users of this machine know about the workaround. 
> I'll report the bug if someone will tell me how.

I think you just did report it :-)

Well, it's something that should be fixed in the kernel, either it's a 
kernel bug or hardware busted in some way that we should be detecting.

How is it failing to install, is it locking up at some point, etc?
