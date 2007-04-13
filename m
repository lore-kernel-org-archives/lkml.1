Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXDMNvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXDMNvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXDMNvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:51:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36892 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbXDMNvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:51:50 -0400
X-Sasl-enc: KeWYRvOmTX8Ds7LXR4Skkk+u+5/LaohSFkENVrNWQgSv 1176472310
Date: Fri, 13 Apr 2007 10:51:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070413135128.GA17921@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net> <20070412204413.GA3151@zarina> <20070413005112.GA20890@khazad-dum.debian.net> <41840b750704121934g2771cc0er308eb4f9c8a1cb80@mail.gmail.com> <20070413023659.GA17467@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413023659.GA17467@zarina>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Anton Vorontsov wrote:
> > With fixed-units files, having *_energy and *_capacity isn't too clear
> > either... Nor is it consistent with SBS, since SBS uses "capacity" to
> > refer to either energy or charge, depending on a units attribute.
> > 
> > As a compromise, how about using "energy" and "charge" for quantities,
> > and "charging" (i.e., a verb) when referring to the operation?
> 
> It would be great compromise! Please please please!

I can live with it, although I'd rather just use the units (zero margin of
error or confusion).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
