Return-Path: <linux-kernel-owner+w=401wt.eu-S1161215AbXBAGNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161215AbXBAGNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXBAGNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:13:38 -0500
Received: from terminus.zytor.com ([192.83.249.54]:44016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161215AbXBAGNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:13:38 -0500
Message-ID: <45C18506.5090001@zytor.com>
Date: Wed, 31 Jan 2007 22:13:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc7 mtrr handling
References: <200701312046.02196.sebastian_ml@gmx.net>
In-Reply-To: <200701312046.02196.sebastian_ml@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> 
> But now /proc/mtrr shows 256MB of video ram, same as lspci, whereas the 
> real amount of video ram (as properly detected by X) is only 128MB.
> 

The size of the aperture doesn't have to match the actual amount of 
memory.  For many cards it doesn't.

	-hpa
