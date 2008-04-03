Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYDCPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYDCPZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbYDCPZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:25:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43526 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYDCPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:25:45 -0400
Message-ID: <47F4F6D7.4050908@s5r6.in-berlin.de>
Date: Thu, 03 Apr 2008 17:25:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: x.guimard@free.fr, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, petkovbb@gmail.com
Subject: Re: Proposed patch for IDE missing commands
References: <47F47324.80108@free.fr> <47F47324.80108@free.fr> <9ea470500804030228p3077456ai4a756aa46116aa4c@mail.gmail.com> <200804031220.07380.elendil@planet.nl>
In-Reply-To: <200804031220.07380.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Boris Petkov wrote:
>> Please, rebase/redo your patch against latest -rc kernel (in this case
>> 2.6.25-rc8) und run it through scripts/checkpatch.pl in order to adjust it
>> to the kernel coding style. See Documentation/CodingStyle for details.

Why don't linux kernel insiders help first-time contributors here a bit
and simply repost the patch with style fix-up?  That would be a matter
of 10 minutes or so and a more valuable contribution than a mere
RTFCodingStyle.

> Suggest you also read Documentation/SubmittingPatches for the correct way to 
> sign off a patch and such.

Yes, the sign-off is in general required already from the original author.
-- 
Stefan Richter
-=====-==--- -=-- ---==
http://arcgraph.de/sr/
