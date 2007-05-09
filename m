Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbXEITWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbXEITWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbXEITWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:22:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46549 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXEITWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:22:33 -0400
Message-ID: <46421F77.3050704@garzik.org>
Date: Wed, 09 May 2007 15:22:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Current -git kernel kills X
References: <4641398F.5050203@garzik.org> <4641C7AC.4050309@rtr.ca>
In-Reply-To: <4641C7AC.4050309@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>>  
>> Symptoms: Machine boots successfully to gdm (GNOME) login screen.  
>> When logging in, the session immediately dies.  Dialog "your session 
>> lasted less than 10 seconds" appears.  I click OK, and am returned to 
>> the gdm login screen.
>>
>> Reproducability: 100%
> 
> Mmm... sounds more like a GNOME bug/crash than an X crash.

Whichever.  As I noted, the kernel is the variable in the equation that 
makes things work, or not.

	Jeff



