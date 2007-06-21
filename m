Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXFUT1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXFUT1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXFUT1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:27:03 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbXFUT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:27:01 -0400
Message-ID: <467AD101.4020107@zytor.com>
Date: Thu, 21 Jun 2007 12:26:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Peter Rabbitson <rabbit@rabbit.us>
CC: linux-kernel@vger.kernel.org
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
References: <467AB4CF.7030904@rabbit.us>
In-Reply-To: <467AB4CF.7030904@rabbit.us>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Rabbitson wrote:
> 
> I have captured dmesg output without mem[5], with mem=3900M[6] and
> mem=2048M[7].
> 

What does /proc/mtrr look like in the two cases?

	-hpa
