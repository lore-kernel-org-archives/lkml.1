Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbXCEUbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbXCEUbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXCEUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:31:45 -0500
Received: from rtr.ca ([64.26.128.89]:1393 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXCEUbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:31:44 -0500
Message-ID: <45EC7E2D.9050508@rtr.ca>
Date: Mon, 05 Mar 2007 15:31:41 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jon Wikne <wikne@cheetah.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: piix.c - previously available patch not implemented
References: <45EC654F.7030209@cheetah.uio.no>
In-Reply-To: <45EC654F.7030209@cheetah.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Wikne wrote:
> Hi list,
> 
> Last year, around 2.6.16.*, there was a patch around that helped
> me get the PIIX driver to run with the Intel 82801FBM (ICH6M) chip
> on my Toshiba Tecra A3 laptop.

Time to switch your kernels over to libata,
where that chip is fully supported.

??
