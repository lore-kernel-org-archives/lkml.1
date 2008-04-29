Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbYD2VCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbYD2VCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYD2VCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:02:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbYD2VCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:02:15 -0400
Message-ID: <48178CD0.7090707@zytor.com>
Date: Tue, 29 Apr 2008 14:02:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Kernel bloating being adressed?
References: <20080429212106.458a0ed6.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20080429212106.458a0ed6.Kristoffer.Ericson@Gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
> Greetings,
> 
> Ive seen some previous discussions on the subject but are there any people activly working on it?
> As an embedded dev size does matter :)
> 

There are several people working on it; e.g. the linux-tiny project.  A 
lot of this stuff is under CONFIG_EMBEDDED.

	-hpa
