Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZIAIcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZIAIcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZIAIcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:32:22 -0400
Received: from ns.unixsol.org ([193.110.159.2]:40498 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbZIAIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:32:22 -0400
Message-ID: <4A9CDC17.8060207@unixsol.org>
Date: Tue, 01 Sep 2009 11:32:23 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add support for Rotronic silver/white handset
 in cm109 driver
References: <4A9ACD69.5030501@unixsol.org> <20090901021017.26A96526EA5@mailhub.coreip.homeip.net>
In-Reply-To: <20090901021017.26A96526EA5@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov scribbled:
> Hi Georgi,
> 
> On Sun, Aug 30, 2009 at 10:05:13PM +0300, Georgi Chorbadzhiyski wrote:
>> The following patch adds support for yet another keymap in
>> cm109 driver. Rotronic silver/white is USB "Skype" handset
>> sold in Bulgaria and Serbia (according to Google). With this
>> cheap stuff a picture is the only way to identify what you've
>> got, so here is one:
>>    http://www.reset.bg/catalog/images/skyphoneusbbelihcek.jpg
>>
> 
> While there is nothing wrong with the patch I am hesitant to apply it.
> Any chance we could push it onto HAL or maybe have your application to
> load appropriate keymap? I know we can't do it automatically because
> vendor and product IDs are the same for all these devices... It's just
> putting every keymap into the kernel is not sustainable.

Sure, no problem.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
