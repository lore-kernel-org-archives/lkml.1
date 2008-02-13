Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbYBMJWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbYBMJWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYBMJV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:21:56 -0500
Received: from pip13.gyao.ne.jp ([61.122.117.251]:55796 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765521AbYBMJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:21:52 -0500
Date: Wed, 13 Feb 2008 18:20:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest list of unused Kconfig variables
Message-ID: <20080213092038.GA16692@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:56:34AM -0500, Robert P. J. Day wrote:
>   latest output here, sorted by architecture:
> 
> http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> 
> as always, there will probably be some false positives for one reason
> or another.
>

>>>>> SH_SDK7780_STANDALONE
arch/sh/boards/renesas/sdk7780/Kconfig:7:config SH_SDK7780_STANDALONE

is taken care of, thanks.
