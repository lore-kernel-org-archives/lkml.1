Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbXI0P0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbXI0P0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXI0P0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:26:31 -0400
Received: from mail.fuw.edu.pl ([193.0.80.14]:33942 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbXI0P0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:26:31 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 11:26:30 EDT
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: "Marco Tralli" <marco.tralli@snapon.com>
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 17:30:14 +0200
User-Agent: KMail/1.9.5
Cc: "Jordan Crouse" <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
In-Reply-To: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271730.14555.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 16:44, Marco Tralli wrote:
> Hello all,
> 
> I have random hangs on kernel boot or after few minutes on a NatSemi Geode
> GX1 based PC-104 (from Advantech) using kernel 2.6.23-rc6. The system locks,
> no way to use SysRq key, no usefull logs.

Please see: http://bugzilla.kernel.org/show_bug.cgi?id=9086

Greetings,
Rafael
