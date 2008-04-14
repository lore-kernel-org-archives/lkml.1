Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbYDNVr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbYDNVr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbYDNVq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:46:58 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46834 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756759AbYDNVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:46:56 -0400
X-Sasl-enc: U8h9rgM5z7gYvzdN38ZKn9ekFYp5pXr1sCTs8lCjIhQy 1208209615
Date: Mon, 14 Apr 2008 18:46:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Message-ID: <20080414214653.GB9815@khazad-dum.debian.net>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804141400.41319.IvDoorn@gmail.com> <200804142006.51224.carlos@strangeworlds.co.uk> <200804142304.42716.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804142304.42716.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Ivo van Doorn wrote:
> Completely overlooked the patch.
> I found it in my archives and just acked it. :)

Unless you want extra trouble and work on your hands when merge time
comes, I would really appreciate a tree with all pending rfkill patches
applied to base my work on.   Right now, I am using 2.6.25-rc8-mm2.

May I suggest you open a git tree somewhere that we can use to track the
rfkill pending patches that are not in mainline yet? :-)

If you don't have a git server in mind already, I suggest http://repo.or.cz

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
