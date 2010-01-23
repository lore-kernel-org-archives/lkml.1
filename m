Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136Ab0AWVUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0AWVUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783Ab0AWVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:20:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab0AWVUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:20:14 -0500
Message-ID: <4B5B38C1.5080109@hhs.nl>
Date: Sat, 23 Jan 2010 18:58:25 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: George Joseph <George.joseph@fairview5.com>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] Status of Andigilog asc7621 driver submitted by
 George	Joseph on 2008-05-29
References: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
In-Reply-To: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/23/2010 06:52 PM, Jaswinder Singh Rajput wrote:
> Andigilog asc7621 driver submitted by George Joseph on 2008-05-29,
> This chip is used by various Intel Motherboards.
>
> Is it still under review and testing :
>
> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-May/023257.html
>
> http://www.spinics.net/lists/lm-sensors/msg26915.html
>
> http://www.spinics.net/lists/lm-sensors/msg26916.html
>
> http://www.lm-sensors.org/wiki/Devices
>

I guess this is partly my fault, I started a review but never finished
it. One of the big problems is that George did many things completely
different to how every other single hwmon driver does things. Which made
the review harder then necessary, and more over made me wonder if we
should accept the driver in that incarnation at all.

Then a lot of things happened and I never got around to doing anything
with it at all.

I just checked my Drafts folder, and I still have my unfinished review
in there. So if there is interest I can send that, note that it is
not a complete review though (there is a note in there which part
of the code is reviewed and which still needs to be reviewed).

Regards,

Hans
