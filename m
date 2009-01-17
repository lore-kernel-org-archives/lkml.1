Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbZAQA5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbZAQA5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZAQA5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:57:30 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:43557 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbZAQA5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:57:30 -0500
Message-ID: <49712CF0.2050605@lwfinger.net>
Date: Fri, 16 Jan 2009 18:57:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hp-wmi: fix regressions caused by missing if statement
References: <200901170013.55786.elendil@planet.nl> <200901170131.22541.elendil@planet.nl> <200901170155.02757.elendil@planet.nl>
In-Reply-To: <200901170155.02757.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
> 
> hp-wmi: fix regressions caused by missing if statement
>     
> Error was introduced in commit fe8e4e039dc3.
>     
> Signed-off-by: Frans Pop <elendil@planet.nl>
> ---
>> On Saturday 17 January 2009, Frans Pop wrote:
>>> When I first booted .29-rc2 my HP 2510p notebook hung while loading
>>> hp-wmi, which I have listed in /etc/modules. Hard poweroff was
>>> needed.
> 
> And this obvious patch fixes the regression (tested).
> 
> Andrew: I've added you as the broken patch also went via you.
> 
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
