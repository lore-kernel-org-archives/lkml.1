Return-Path: <linux-kernel-owner+w=401wt.eu-S936964AbXGMS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936964AbXGMS16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbXGMS1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:27:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbXGMS1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:27:48 -0400
Date: Fri, 13 Jul 2007 14:27:39 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
Message-ID: <20070713182739.GE28567@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4697B7DB.3030006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4697B7DB.3030006@zytor.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 10:35:23AM -0700, H. Peter Anvin wrote:
 > It causes build failures on i386.
 > 
 > Yet another case of unnecessary divergence between i386 and x86-64 I'm
 > afraid...

Already fixed in cpufreq.git, pull request about to linus.

	Dave

-- 
http://www.codemonkey.org.uk
