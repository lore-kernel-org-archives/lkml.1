Return-Path: <linux-kernel-owner+w=401wt.eu-S1764327AbZFLVgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764327AbZFLVgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZFLVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:36:34 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:60813 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZFLVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:36:34 -0400
Message-ID: <4A32CA58.60000@f2s.com>
Date: Fri, 12 Jun 2009 22:36:24 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 5/7] mmc: tmio_mmc: map SD control registers after enabling
 the MFD cell
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com> <1244139157-16404-6-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1244139157-16404-6-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel wrote:
> ASIC3 can disable the memory, so we need to wait for mfd_cell->enable
> to enable the memory before we can map the SD control registers.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Pierre Ossman <pierre@ossman.eu>

Acked-by: Ian Molton <ian@mnementh.co.uk>
