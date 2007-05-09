Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXEINIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXEINIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXEINH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:07:59 -0400
Received: from rtr.ca ([64.26.128.89]:4041 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbXEINH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:07:58 -0400
Message-ID: <4641C7AC.4050309@rtr.ca>
Date: Wed, 09 May 2007 09:07:56 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Current -git kernel kills X
References: <4641398F.5050203@garzik.org>
In-Reply-To: <4641398F.5050203@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>  
> Symptoms: Machine boots successfully to gdm (GNOME) login screen.  When 
> logging in, the session immediately dies.  Dialog "your session lasted 
> less than 10 seconds" appears.  I click OK, and am returned to the gdm 
> login screen.
> 
> Reproducability: 100%

Mmm... sounds more like a GNOME bug/crash than an X crash.

I've had this situation several times in the past with GNOME,
and each time it turned out to be some missing config file
or subdir that got wiped in a system update or reconfig.

Generally I only boot into GNOME when absolutely necessary
to test something under that environment, so I'm no expert.

KDE for me.

Cheers

