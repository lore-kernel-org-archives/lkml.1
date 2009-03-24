Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZCXO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZCXO24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbZCXO2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:28:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZCXO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:28:43 -0400
Message-ID: <49C8EE38.3030701@redhat.com>
Date: Tue, 24 Mar 2009 15:29:12 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090303 Fedora/3.0-1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
References: <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>	<498953DF.5050306@redhat.com>	<20090204131708.GA2739@srcf.ucam.org>	<20090204142606.1823661b@hyperion.delvare>	<20090204142015.GB3923@srcf.ucam.org>	<20090210145716.105ab58b@hyperion.delvare>	<20090210140829.GA25397@srcf.ucam.org>	<49919E08.5050002@redhat.com>	<20090210172408.400cacee@hyperion.delvare>	<20090227132740.GF1482@ucw.cz>	<68676e00903240539i119b6d26j516ee131d4cd6781@mail.gmail.com>	<49C8DE51.2010103@redhat.com> <20090324144315.196273ed@hyperion.delvare>
In-Reply-To: <20090324144315.196273ed@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/24/2009 02:43 PM, Jean Delvare wrote:
> Hi Hans, Luca,
>
> On Tue, 24 Mar 2009 14:21:21 +0100, Hans de Goede wrote:
>> On 03/24/2009 01:39 PM, Luca Tettamanti wrote:
>>> the merge window for .30 is now open, what are we going to do with this issue?
>> I think the consensus was to make the default strict and to merge the atk0110
>> driver, right?
>
> Yes.
>
>> Note that we've been running this setup in Fedora kernels for quite a while now,
>> and have had only one bug report, which was solved by simply explaining why this
>> was done.
>
> Maybe the explanation in question could be added somewhere, either in
> the help text of CONFIG_HWMON, or somewhere under Documentation/, or on
> the lm-sensors.org wiki?

I think having an explanation somewhere would be great, not sure if the explanation
in question was all that great though (and it is burried in between a gazillion other
kernel bugs, so a bit hard to find).

Regards,

Hans
