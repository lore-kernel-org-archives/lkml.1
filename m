Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751803AbYLRILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbYLRILX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYLRILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:11:13 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:25668 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLRILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nMm1dj26mBHewteZKZcPvqW3s4/joskSyah60X4MfFRjncTunJ+LkqkyESlrITKkK9
         Db47tqk7+12BGNALUIxBp9iXXn7XJsvmGuVgf5Xx+31smm3c+ZOh77hqO52f8jJmKOzo
         eo2VV1QEAbMSbsMaiQOpEuXJSZeiiYBdHcIfc=
Message-ID: <494A059A.8050602@gmail.com>
Date: Thu, 18 Dec 2008 00:11:06 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Brian J. Murrell" <brian@interlinx.bc.ca>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
References: <gi247o$iog$1@ger.gmane.org> <200812161625.37318.rjw@sisk.pl> <gi8jf1$m5f$5@ger.gmane.org> <200812161713.08451.rjw@sisk.pl> <20081216163746.GA9478@srcf.ucam.org> <gi8qoj$m5f$7@ger.gmane.org> <20081216205335.GA14332@srcf.ucam.org> <20081218075226.GD2110@ucw.cz>
In-Reply-To: <20081218075226.GD2110@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-12-16 20:53:35, Matthew Garrett wrote:
>   
>> On Tue, Dec 16, 2008 at 06:07:15PM +0000, Brian J. Murrell wrote:
>>     
>>> On Tue, 16 Dec 2008 16:37:46 +0000, Matthew Garrett wrote:
>>>       
>>>> I seem to be missing the original message, but: no, s2ram doesn't exist
>>>> in Ubuntu because pm-utils handles that role.
>>>>         
>>> Well, that's *their* argument but lots of people think otherwise.  There 
>>> appears to be no shortage of people for whom pm-utils does NOT work yet 
>>> s2ram does.  https://bugs.launchpad.net/ubuntu/+source/uswsusp/+bug/134238
>>>       
>> The right answer to "This piece of software contains bugs" is not 
>> "Provide two pieces of software with the same features but different 
>> bugs". The only real functional difference between the two is that
>>     
>
> Yes, and that's why pm-utils should die: they have design problems
> (depend on hal, can't be pagelocked, unusable for suspend debugging).
> 									Pavel
>   
When using ubuntu intrepid, s2ram
did work, but instead of grabbing
the package from ubuntu, I used Debian
SID instead. (I have a tendency of mixing
packages);

regards;

Justin P. Mattock


