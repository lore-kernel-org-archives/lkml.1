Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYDGPpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYDGPpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYDGPps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:45:48 -0400
Received: from rtr.ca ([76.10.145.34]:3371 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYDGPpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:45:47 -0400
Message-ID: <47FA41AB.6070206@rtr.ca>
Date: Mon, 07 Apr 2008 11:45:47 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Xavier <x.guimard@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Proposed patch for IDE missing commands
References: <47F47324.80108@free.fr>
In-Reply-To: <47F47324.80108@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier wrote:
> Hi all,
> 
> I'm working for the french Gendarmerie Nationale and we've decided to 
> publish our patch for the kernel that provides some missing IDE commands 
> to access to protected areas (HPA and DCO).
..

What's the purpose of putting this stuff in-kernel,
as opposed to just doing it from userspace ?

Thanks.
