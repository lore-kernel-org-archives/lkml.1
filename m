Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbYDSDC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbYDSDC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYDSDCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:02:21 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:43425 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYDSDCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:02:20 -0400
Message-ID: <48096179.4060803@keyaccess.nl>
Date: Sat, 19 Apr 2008 05:05:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew <jackdachef@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org> <20080418193802.GK7674@cvg> <20080418200338.GL7674@cvg>
In-Reply-To: <20080418200338.GL7674@cvg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-04-08 22:03, Cyrill Gorcunov wrote:

> | it seems drivers/acpi/thermal.c has a small nit
> | 
> | 881:	/* sys I/F for generic thermal sysfs support */
> | 882:	#define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
> | 
> | but it should multiply by 1000 meguess
> | 
> 
> oh, i'm wrong, sorry

? How are you wrong ?

Rene.
