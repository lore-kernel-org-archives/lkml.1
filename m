Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXFQWTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXFQWTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbXFQWTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:19:45 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:64217 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753821AbXFQWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:19:45 -0400
Date: Mon, 18 Jun 2007 00:19:42 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617221942.GC6207@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617213355.GC3430@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 05:33:55PM -0400, Dave Jones wrote:
>  > What would the name be of such module?
> 
> intel-agp
> 
> Though by the looks of things, with the working kernel, you don't have
> it loaded (it's dependant upon the 'agpgart' module, which prints the
> "Detected" line that was missing).

I can rmmod intel-agp without problems.
The agpgart module isn't loaded.

-- 
Carlo Wood <carlo@alinoe.com>
