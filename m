Return-Path: <linux-kernel-owner+w=401wt.eu-S1765423AbYAaIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765423AbYAaIdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbYAaIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:33:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbYAaIdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:33:37 -0500
Message-ID: <47A187DB.5010201@redhat.com>
Date: Thu, 31 Jan 2008 03:33:31 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: about relocs.c on x86
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
In-Reply-To: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> why not rename relocs.c to relocs_32.c?

Because we're trying to get rid of all the _32 and _64 files?

	-- Chris
