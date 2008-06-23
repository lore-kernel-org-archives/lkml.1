Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYFWFPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYFWFPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYFWFP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:15:29 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:36111 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbYFWFP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:15:27 -0400
Message-ID: <485F32C0.9060401@hhs.nl>
Date: Mon, 23 Jun 2008 07:21:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc,	enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl>	<485E6F12.4010307@keyaccess.nl> <485E94ED.10602@hhs.nl>	<485E992B.8010101@keyaccess.nl>  <485ECB23.4010305@keyaccess.nl> <1214185482.3001.45.camel@rzhang-dt.sh.intel.com>
In-Reply-To: <1214185482.3001.45.camel@rzhang-dt.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui wrote:
> On Mon, 2008-06-23 at 05:58 +0800, Rene Herman wrote:
>> On 22-06-08 20:25, Rene Herman wrote:
>>
>>> Another way to solve it _could_ be to just make up a device link if
>>> something generic is available so that sensors doesn't trip over it
>>> in the first place but I don't know if that's a good option. You
>>> might.
>> This also works for me and, if correct, is ofcourse better than the
>> CONFIG option. Wants a comment from the thermal_zone side (for which
>> Zhang Rui seems the correct CC?) though.
> Hi, Rene and Hans,
> 
> Thank you for your efforts on this issue and sorry for the late
> response, I did not check my email during the whole weekend.
> 
> About the hwmon ABI, after the device symbol link is created, are there
> any other ABIs required in the device node? 

Not that I know of, Jean ?

Regards,

Hans
