Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZEMHWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZEMHWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 03:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZEMHVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 03:21:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:58963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZEMHVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 03:21:52 -0400
Subject: Re: [PATCH 6/10 -tip] x86: early_init_intel() user of Advanced
 Power Management features
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
In-Reply-To: <20090513061801.GD9991@alberich.amd.com>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam>
	 <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam>
	 <1242142849.2547.19.camel@ht.satnam> <1242142908.2547.20.camel@ht.satnam>
	 <20090513061801.GD9991@alberich.amd.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 12:50:47 +0530
Message-Id: <1242199247.4218.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 08:18 +0200, Andreas Herrmann wrote:
> On Tue, May 12, 2009 at 09:11:48PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > use X86_FEATURE_CONSTANT_TSC to determine TSC Invariance
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> I'd like to NAK this as well.

Thanks, trashed.

--
JSR

