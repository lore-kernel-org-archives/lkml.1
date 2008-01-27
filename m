Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYA0SQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYA0SQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYA0SQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:16:02 -0500
Received: from smtp25.orange.fr ([193.252.22.23]:21699 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207AbYA0SQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:16:00 -0500
X-ME-UUID: 20080127181555393.602111C0008D@mwinf2514.orange.fr
Message-ID: <479CE747.8080606@free.fr>
Date: Sun, 27 Jan 2008 21:19:19 +0100
From: Stephane Ascoet <stephaneascoet@free.fr>
Organization: Conseils pour que le progres profite a tous les terriens
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Troubles waking up from suspend (S3) - how to debug?
References: <200801271842.38007.bonbons@linux-vserver.org>
In-Reply-To: <200801271842.38007.bonbons@linux-vserver.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont a écrit :
> I'm currently trying out suspend (S3) on a few machines but none of them wakes 
> up completely/properly (I have a few more hosts I'm planning to try suspend 
> on once I can get useful information out of those not waking up properly).
> 
> Tested kernels: 2.6.24(-rc8), on one 2.6.23.8
> 
> To suspend I enter the following from console:
>   echo -n mem > /sys/power/state



Bonjour, it seems for me that using echo isn't the right way. You could 
follow instructions at the end of: 
<http://community.ofset.org/index.php/Freeduc-cd17_how_to>

-- 
Bien cordialement, Stephane Ascoet, conseils pour que la technologie 
soit un progres respectueux de la vie.
Album photo:<http://www.flickr.com/photos/stephaneascoet/>, 
site:<http://community.ofset.org/wiki/User:Sascoet>
