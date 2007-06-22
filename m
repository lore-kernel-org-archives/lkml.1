Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbXFVVR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbXFVVR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXFVVRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:17:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42707 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbXFVVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:17:51 -0400
X-Sasl-enc: VS1GrtYtbUXnbptmNVGAo+mSHJOfgvZIQeS9tK3qa9DK 1182547088
Date: Fri, 22 Jun 2007 18:17:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlo Wood <carlo@alinoe.com>, Arjan van de Ven <arjan@infradead.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070622211746.GB21769@khazad-dum.debian.net>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622162142.GA603@alinoe.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Carlo Wood wrote:
> So far I found out that it's RAID only.

If you change the IO schedulers, does it help?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
