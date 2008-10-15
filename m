Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYJOLUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYJOLUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYJOLU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:20:27 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:14504 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYJOLU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:20:26 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48F5D1F1.3060702@tremplin-utc.net>
Date: Wed, 15 Oct 2008 13:20:17 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: lm-sensors@lm-sensors.org, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Yan Burman <burman.yan@gmail.com>
Subject: Re: Accelerometer driver for HP laptops
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net> <20081015072511.GA20607@atrey.karlin.mff.cuni.cz> <48F5A0C8.1080102@tremplin-utc.net> <20081015105805.GD4247@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081015105805.GD4247@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:

> 
>> I've got already a changelog ready. Give me a couple of days to clean
>> things up and I'll send it to akpm myself :-)
> 
> Ok, I'd like to help with cleaning... let me know if I can help some more.
Hi,
Thanks a lot for this patch.
> 
> * whitelist hp2133
Great!
> 
> * the driver has different name now.
That was too obvious for me to notice ;-)
> 
> * remove /** from comments that are not linuxdoc compliant.
Hum... I'll try to fix the comments to make them linuxdoc compliant. I
must be missing something obvious, but do you know where is the doc
about linuxdoc?
> 
> * remove /dev/accel. We can reintroduce it when it works
Right, that's probably the safest for now.

See you,
Eric
