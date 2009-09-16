Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbZIPQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbZIPQ5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbZIPQ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:57:17 -0400
Received: from fifo99.com ([67.223.236.141]:39188 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759671AbZIPQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:57:16 -0400
Subject: Re: [PATCH] enabling ACS P2P upstream forwarding
From: Daniel Walker <dwalker@fifo99.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, "Kay, Allen M" <allen.m.kay@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
In-Reply-To: <20090916174144.3282614c@lxorguk.ukuu.org.uk>
References: <57C9024A16AD2D4C97DC78E552063EA3E05DC218@orsmsx505.amr.corp.intel.com>
	 <1253059937.11643.527.camel@desktop> <20090916093446.5ea81b8a@bike.lwn.net>
	 <1253119153.11643.583.camel@desktop>
	 <20090916174144.3282614c@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:58:14 -0700
Message-Id: <1253120294.11643.588.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 17:41 +0100, Alan Cox wrote:
> > Shouldn't all patches be sent as plain text untouched? I don't think I
> > should necessarily need a specific email client to strip off some
> > characters..
> 
> Plain text is 7bit (netascii). People have unicode names.

Is "=20" or "=3D" unicode encodings? Seems like we do allow UTF-8 for
patches.. For this patch I don't see why you would need unicode in the
actual patch content or for names tho.

Daniel

