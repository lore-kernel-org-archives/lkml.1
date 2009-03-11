Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZCKOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZCKOc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZCKOcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:32:48 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:58887 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZCKOcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:32:48 -0400
Message-ID: <49B7CA28.3030706@mnementh.co.uk>
Date: Wed, 11 Mar 2009 14:26:48 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Subject: Re: [PATCH 01/05] tmio_mmc: Fix one off, use resource_size() in probe()
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se> <20090311125854.1563.34525.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125854.1563.34525.sendpatchset@rx1.opensource.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> From:  Magnus Damm <damm@opensource.se>
> 
> Update the tmio_mmc code to use resource_size(). With this
> patch applied the correct resource size is passed to ioremap().

Acked.

