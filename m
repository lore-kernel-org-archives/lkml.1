Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0BEIBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:01:24 -0500
Received: from mail.crca.org.au ([67.207.131.56]:38710 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0BEIBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:01:22 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B6BD0C8.5020400@crca.org.au>
Date: Fri, 05 Feb 2010 19:03:20 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/2] PM / Runtime: Add sysfs switch for	disabling
 device run-time PM (rev. 2)
References: <201001180129.55219.rjw@sisk.pl> <201001212357.46483.rjw@sisk.pl>	<201001212359.38886.rjw@sisk.pl> <20100204224623.GB1436@ucw.cz>
In-Reply-To: <20100204224623.GB1436@ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel et al.

Pavel Machek wrote:
> Hi!
> 
>>  /*
>> + *	control - Report/change current runtime PM setting of the device
>> + *
>> + *	Runtime power management of a device can be blocked with the help of
>> + *	this attribute.  All devices have one of the following two values for
>> + *	the power/control file:
>> + *
>> + *	 + "auto\n" to allow the device to be power managed at run time;
>> + *	 + "on\n" to prevent the device from being power managed at run time;
> 
> I find interface with mandatory \n quite 'interesting'. 

Agreed.

> Plus english is strange here. All devices have ... "auto" to allow...?
> Strange formulation. List the values first, then add "write ... to allow"?

It seems okay to me because of the preceding sentence ending in a colon.

Regards,

Nigel

