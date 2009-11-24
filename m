Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbZKXHjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbZKXHjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbZKXHjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:39:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:4810 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757704AbZKXHjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:39:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,276,1257148800"; 
   d="scan'208";a="749860616"
Date: Tue, 24 Nov 2009 10:16:02 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com
Subject: Re: [PATCH]crypto: Add ghash algorithm test before provide to users
Message-ID: <20091124151602.GA27037@youquan-linux.bj.intel.com>
References: <20091119004246.GB28448@youquan-linux.bj.intel.com> <20091123122357.GE6424@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123122357.GE6424@gondor.apana.org.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +/*
> > + * HMAC-MD5 test vectors from RFC2202
> >  /*
> >   * HMAC-MD5 test vectors from RFC2202
> >   * (These need to be fixed to not use strlen).
> 
> This adds two bogus lines.  I've removed them for you but please
> be more careful next time.
> 
Sure. Thanks a lot! 

-Youquan
