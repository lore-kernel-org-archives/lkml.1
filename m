Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbZD3Pr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbZD3Pr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZD3Pmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48018 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757807AbZD3Pma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:30 -0400
X-Sasl-enc: Hn8n7cAbHq3Chids3kU/OjG5OWF3L8otzY2LBG0KtKMu 1241106149
Date: Thu, 30 Apr 2009 12:42:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Theodore Tso <tytso@mit.edu>, Alex Buell <alex.buell@munted.org.uk>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
	question)
Message-ID: <20090430154226.GE28027@khazad-dum.debian.net>
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430113445.GA4809@mit.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Theodore Tso wrote:
> I can try upgrading to it and see if it's any better.  Or maybe
> someone on the Linux-thinkpad mailing list with contacts inside Lenovo
> can bug them.  Sounds like there's no way to work around this except
> for a BIOS-level fix then?  :-(

Either me or Thomas Renninger can get in touch with Lenovo, yes.  As usual,
I need a self-contained, precise report of what is wrong, why it is wrong,
and what should be done to fix it, so that I can forward it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
