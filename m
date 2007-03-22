Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXCVGMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXCVGMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXCVGMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:12:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXCVGMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:12:20 -0400
Date: Thu, 22 Mar 2007 02:10:01 -0400
From: Dave Jones <davej@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070322061001.GA15364@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Willy Tarreau <w@1wt.eu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <20070321151952.02b5612d.akpm@linux-foundation.org> <20070322001050.13588e5e@lxorguk.ukuu.org.uk> <20070321161341.0f87ed60.akpm@linux-foundation.org> <20070321232433.GX943@1wt.eu> <20070321234318.GE9092@redhat.com> <20070322041242.GA29741@1wt.eu> <20070322041751.GB17159@redhat.com> <20070322044540.GA32191@1wt.eu> <20070322050250.GC17159@redhat.com> <20070322055306.GZ943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322055306.GZ943@1wt.eu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 06:53:06AM +0100, Willy Tarreau wrote:

 > At most, they will ask their distro vendor for continued support of the
 > feature (which there will be in the same minor release), and if vendors'
 > feedback show there is enough demand, then we will just have to delay the
 > removal.

Err, this is where we are _today_

	Dave

-- 
http://www.codemonkey.org.uk
