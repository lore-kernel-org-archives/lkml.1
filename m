Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbXEaRuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbXEaRuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXEaRtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:49:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbXEaRtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:49:46 -0400
Date: Thu, 31 May 2007 13:48:33 -0400
From: Dave Jones <davej@redhat.com>
To: Christian Volkmann <haveaniceday@cv-sv.de>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>, ak@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC: 2.6 patch] i386: remove support for the Rise CPU
Message-ID: <20070531174833.GA18959@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christian Volkmann <haveaniceday@cv-sv.de>,
	linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
	ak@suse.de, Linus Torvalds <torvalds@linux-foundation.org>
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <464BB252.8010008@cv-sv.de> <464CC8E1.5010407@cv-sv.de> <20070517214754.GC398@redhat.com> <20070531052238.GX3899@stusta.de> <20070531133106.GA26030@redhat.com> <465F07F0.3000406@cv-sv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465F07F0.3000406@cv-sv.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 07:37:52PM +0200, Christian Volkmann wrote:
 > The SIS550 chip uses the mP6 core according to http://en.wikipedia.org/wiki/MP6
 > May be this code can improve the capability of these SIS550 system on a chip ?
 > 
 > But this should be a different story.

>From what I heard (I've seen nothing definitive) those chips identify
themselves differently.  ISTR that their vendor string is "SIS SIS SIS "

	Dave

-- 
http://www.codemonkey.org.uk
