Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbYETJ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbYETJ7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbYETJ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:59:13 -0400
Received: from stinky.trash.net ([213.144.137.162]:65067 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764152AbYETJ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:59:12 -0400
Message-ID: <4832A0E9.9010207@trash.net>
Date: Tue, 20 May 2008 11:59:05 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: asterisk hangs with RT priority
References: <483054DB.4030504@trash.net>
In-Reply-To: <483054DB.4030504@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> I'm seeing hanging asterisk processes on startup when using
> RT priority with current -git. Unfortunately I'm not sure about
> the last working version, but it was one of the final 2.6.25 rcs.
> The hang stops when executing "schedtool -N $(pidof asterisk)".

The problem is gone in the current -git tree.
