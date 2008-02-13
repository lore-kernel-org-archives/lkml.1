Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbYBMLbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbYBMLbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYBMLbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:31:15 -0500
Received: from pip13.gyao.ne.jp ([61.122.117.251]:19010 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755880AbYBMLbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:31:14 -0500
Date: Wed, 13 Feb 2008 20:30:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tests of undefined CONFIG variables.
Message-ID: <20080213113003.GA17418@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802130552370.19968@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802130552370.19968@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 05:54:12AM -0500, Robert P. J. Day wrote:
>   i've also updated the list of what i call "badref" CONFIG variables
> -- that is, tests of CONFIG_ variables that appear to be undefined
> anywhere in a Kconfig file (which typically represents a meaningless
> test, naturally).
> 
> http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables
> 
For SH:

CONFIG_SERIAL
CONFIG_CPU_HAS_PINT_IRQ
CONFIG_LITTLE_ENDIAN
CONFIG_SH64_PROC_TLB

are now fixed, thanks.
