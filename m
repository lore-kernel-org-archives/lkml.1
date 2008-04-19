Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYDSDRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYDSDRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYDSDRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:17:14 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56167 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYDSDRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:17:13 -0400
Message-ID: <480964F7.3040701@keyaccess.nl>
Date: Sat, 19 Apr 2008 05:20:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew <jackdachef@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org> <20080418193802.GK7674@cvg> <20080418200338.GL7674@cvg> <48096179.4060803@keyaccess.nl>
In-Reply-To: <48096179.4060803@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-04-08 05:05, Rene Herman wrote:
> On 18-04-08 22:03, Cyrill Gorcunov wrote:
> 
>> | it seems drivers/acpi/thermal.c has a small nit
>> | | 881:    /* sys I/F for generic thermal sysfs support */
>> | 882:    #define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
>> | | but it should multiply by 1000 meguess
>> |
>> oh, i'm wrong, sorry
> 
> ? How are you wrong ?

(okay, it's only the name which is wrong; it's DECIKELVIN_TO_MILLICELSIUS)

Rene.
