Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZATV7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZATV7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbZATV67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:58:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:2766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZATV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GpQAuUbpnhc/xFPk8E8KV95rB1T22X4kmuEnRArquH6wKoPhV0LaPUIIRwJfh3v54P
         M2w7J5b4E3rS/+6C9uQFqrSiQfJ48JHiml2c2/6YsyTrzH3xXdKnrozeJVOZlJska2CD
         UrqPIg1VXgJbLVOOqbjzUlSqNgE+ubpMfPD84=
Date: Wed, 21 Jan 2009 00:58:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: James Chapman <jchapman@katalix.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org,
       Michal Ostrowski <mostrows@earthlink.net>
Subject: Re: [PATCH 5/5] net: pppoe,pppol2tp - register channels with
	explicit net
Message-ID: <20090120215849.GB941@localhost>
References: <20090120140510.228815074@gmail.com>> <4975dc14.0637560a.7f8e.729c@mx.google.com> <49764890.5010403@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49764890.5010403@katalix.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[James Chapman - Tue, Jan 20, 2009 at 09:56:32PM +0000]
| Cyrill Gorcunov wrote:
| > In PPPo[E|L2TP] we could explicitly point which net namespace
| > we're going to use for channels - make it so.
| > 
| > CC: James Chapman <jchapman@katalix.com>
| > CC: Michal Ostrowski <mostrows@earthlink.net>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| 
| This one's ok by me too for pppol2tp.
| 
| Signed-off-by: James Chapman <jchapman@katalix.com>
| 

...

| 
| 
| -- 
| James Chapman
| Katalix Systems Ltd
| http://www.katalix.com
| Catalysts for your Embedded Linux software development
| 

Thanks a lot for testing, James! I really appreciate!

		- Cyrill -
