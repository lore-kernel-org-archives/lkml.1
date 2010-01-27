Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112Ab0A0QJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0A0QJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529Ab0A0QJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:09:18 -0500
Received: from banach.math.auburn.edu ([131.204.45.3]:59957 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0A0QJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:09:17 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 11:09:17 EST
Date: Wed, 27 Jan 2010 10:27:49 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: v4l-dvb tree build warning
In-Reply-To: <4B5FF2CE.8070304@redhat.com>
Message-ID: <alpine.LNX.2.00.1001271026240.16311@banach.math.auburn.edu>
References: <20100127121223.9af2253f.sfr@canb.auug.org.au> <4B5FF2CE.8070304@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Hans de Goede wrote:

> Gi,
>
> On 01/27/2010 02:12 AM, Stephen Rothwell wrote:
>> Hi Mauro,
>> 
>> Today's linux-next build (x86_64 allmodconfig) produced this warning:
>> 
>> drivers/media/video/gspca/sq905c.c: In function 'sd_config':
>> drivers/media/video/gspca/sq905c.c:207: warning: unused variable 'i'
>> 
>> Introduced by commit 6436e86d8920520f6650bedaa816ed596c7c30b7 ("V4L/DVB
>> (14006): gscpa_sq905c: Better detection of CIF resolution cameras").
>> 
>
> Ack, my bad. Note that a fix for this is pending in Jean Francois' gscpa
> tree, and AFAIK he has send a pull request.
>
> Regards,
>
> Hans
>

OK, good. Wherever it came from, it is gone. So disregard the question of 
how to do it, in my previous message.

Theodore Kilgore
