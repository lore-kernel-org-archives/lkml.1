Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZHZE0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZHZE0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZHZE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:26:20 -0400
Received: from kroah.org ([198.145.64.141]:56570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZHZE0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:26:19 -0400
Date: Tue, 25 Aug 2009 21:24:12 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Christian Lamparter <chunkeey@web.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stephen Chen <Stephen.Chen@atheros.com>,
       Zhifeng Cai <zhifeng.cai@atheros.com>,
       Cliff Holden <Cliff.Holden@atheros.com>,
       Christoph Hellwig <hch@infradead.org>,
       Len Widra <Len.Widra@atheros.com>
Subject: Re: Initial work for ar9271
Message-ID: <20090826042412.GA26690@kroah.com>
References: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:03:08PM -0700, Luis R. Rodriguez wrote:
> I'm not yet sure if working with a separate repo or staging might be
> best here as the driver does not yet give STA functionality, the whole
> mac80211 driver part still remains to be developed. Lets play it by
> ear, I'll see if we can get a mailing list created in the meantime
> unless Greg doesn't mind me borrowing the driver project mailing list
> for that.

Not at all, feel free to use it for something like this.

thanks for asking,

greg k-h
