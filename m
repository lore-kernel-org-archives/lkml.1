Return-Path: <linux-kernel-owner+w=401wt.eu-S932195Ab0ANVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0ANVA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258Ab0ANVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:00:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56380 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0ANVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:00:57 -0500
X-Sasl-enc: 3IM9uwx/gMYSkgkJAka0sUWlonuXeawq1Py08ozYXGNF 1263502856
Date: Thu, 14 Jan 2010 19:00:53 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
 unlinking
Message-ID: <20100114210053.GD3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site>
 <20100114205304.GC3814@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114205304.GC3814@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Henrique de Moraes Holschuh wrote:
> On Wed, 13 Jan 2010, Kay Sievers wrote:
> > across the device lifetime by creating hardlinks, in the unusual case
> > that there is a user-writable directory on the same filesystem.
> 
> Does a tmpfs mounted in /dev/shm count as "user-writable directory on the
> same filesystem" ?

Never mind... stupid question really.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
