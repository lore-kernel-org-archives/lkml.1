Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbXFRRh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbXFRRh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbXFRRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:37:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10485 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbXFRRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:37:49 -0400
Date: Mon, 18 Jun 2007 19:37:45 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618173745.GA8054@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Airlie <airlied@gmail.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com
References: <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com> <20070618015636.GA8561@alinoe.com> <21d7e9970706171918p19bc3b13ta747dc76d2677345@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970706171918p19bc3b13ta747dc76d2677345@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 12:18:32PM +1000, Dave Airlie wrote:
> Well it was more for davej's benefit, in theory for your machine with
> a PCIE graphics card you don't need agpgart enabled at all granted it
> shouldn't screw up if it is..

I can't disable it though.

I am not THAT much interested in disabling it however as long as I
get help here to debug this. I am interested in finding out what is
causing the crash, can't stand it to have a bug on my machine without
knowing what it is ;)

-- 
Carlo Wood <carlo@alinoe.com>
