Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553Ab0ATAgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0ATAgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456Ab0ATAgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:36:10 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41185 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0ATAgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:36:09 -0500
Date: Wed, 20 Jan 2010 01:36:03 +0100
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
Message-ID: <20100120003603.GB21011@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at> <1263576588.2751.455.camel@rc-desk> <20100119054715.GA10780@gamma.logic.tuwien.ac.at> <1263920481.4838.32.camel@rchatre-DESK> <1263923990.28066.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1263923990.28066.3.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 19 Jan 2010, Johannes Berg wrote:
> Sorry, no, seems weird. The trace is not very useful unfortunately, is
> this with CONFIG_FRAME_POINTER?

# CONFIG_FRAME_POINTER is not set

Do you need it?

Other things for the .config needed?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GREAT TOSSON (n.)
A fat book containing four words and six cartoons which cost £6.95.
			--- Douglas Adams, The Meaning of Liff
