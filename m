Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009Ab0AKJge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0AKJge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990Ab0AKJge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:36:34 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43403 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340Ab0AKJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:36:33 -0500
X-Sasl-enc: uPGpkRf0L+1Wcck0AZ+OdfzW7aR47h5kc9HHzVfDUf9q 1263202592
Date: Mon, 11 Jan 2010 07:36:28 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ralf Nyren <ralf@nyren.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug found in ext3 quota enabled fs
Message-ID: <20100111093628.GA16080@khazad-dum.debian.net>
References: <op.u6b72biaumhi3g@fujje.vpn.nyren.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.u6b72biaumhi3g@fujje.vpn.nyren.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Ralf Nyren wrote:
> I did an rsync of a remote file to a local ext3 filesystem with journaled
> quotas enabled. Got the kernel BUG report below... I was able to reproduce

http://lkml.org/lkml/2010/1/7/439

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
