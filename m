Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZIJDse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZIJDse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZIJDsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:48:33 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:43442 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753169AbZIJDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:48:32 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: jXY6VlUVM1mgILvXDxGyYAAY2mGWy3UbtSO8BzIOSabN_hM7O.GvBnDa_aJg_mGSaqoprHaGxAob1MA5UH8otKSk6nsqkWNec0RU5QlI9iCx6Q_Nigih0hc9LnqtnyvTatPa7QsI2N7F6fbEi7Lw9okR7V6.z8omF5qwvn1iDRgEjpB8SVo5k4B529FHlDSxMNn2xqY.14N.i4mD4YTYJEMlO3lDbpDo5p8oGsJ0XJq9eY1aoANv5qhcfisyibWkbvsb4zE1B.DDaawMIY0jPTbQ9XZW6qaSTw7Rp3rh
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AA87710.9010901@schaufler-ca.com>
Date: Wed, 09 Sep 2009 20:48:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov> <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org> <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil> <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org> <20090910030121.GA32239@suse.de>
In-Reply-To: <20090910030121.GA32239@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
>   
>> Thanks, all applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>     
>
> Um, wait, what about the sysfs maintainer's review?  :)
>
> I also want to see Casey agree with this as well.
>   

Without being able to provide a better solution in a reasonable
time I don't see that I can responsibly raise an objection. Sure,
I'd rather see a real implementation of xattrs on memory based
file systems, but I can't put the time in to make it happen and
I don't see that it would be "fair" for these people to be held
up by my petty idiosyncrasies on the topic if I'm not willing to
make the investment and do it myself.

Maybe the next time I'm out of work ("Nuts! And I finally got
asking if they wanted to SuperSize it down!") I'll revive my
efforts to eliminate secids from the kernel entirely.

> thanks,
>
> greg k-h
>
>
>   

