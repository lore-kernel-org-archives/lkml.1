Return-Path: <linux-kernel-owner+w=401wt.eu-S936016AbYBAFEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936016AbYBAFEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934978AbYBAFBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:01:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934980AbYBAFBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:01:21 -0500
Message-ID: <47A2A60C.6020902@zytor.com>
Date: Thu, 31 Jan 2008 20:54:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: ijc@hellion.org.uk, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: There are smaller ways to encode a CRC32 table...
References: <20080201045320.11859.qmail@science.horizon.com>
In-Reply-To: <20080201045320.11859.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Spelvin wrote:
> The code to fill it in is smaller than the table itself.
> Is it worth complicating things with some INIT code to reduce
> the stored image size?  (The table is not compressible.)

I think it matters not at all either way.

	-hpa

