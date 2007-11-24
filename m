Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXKXSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXKXSoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXKXSoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:44:25 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1505 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXKXSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:44:24 -0500
Message-ID: <474870F5.4050504@xs4all.nl>
Date: Sat, 24 Nov 2007 19:44:05 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: possible  BUG: unable to handle kernel NULL pointer dereference
 at virtual address 00000000
References: <47481590.8090009@xs4all.nl> <200711241951.37817.rjw@sisk.pl>
In-Reply-To: <200711241951.37817.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 24 of November 2007, Udo van den Heuvel wrote:
>> Hello,
>>
>> What happened in the attached messages?
>> It was on a VIA Epia EN12000, while compiling.
>> Yes, the machine has been stable before and after that issue.
>> So I suspect no hardware issues.
> 
> Which kernel is this?

Sorry for not mentioning:
2.6.23.1
