Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZBABpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZBABpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 20:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBABo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 20:44:57 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48702 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbZBABo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 20:44:57 -0500
X-Sasl-enc: eLQ1ctP7q4lRF+0lR88CgCgshAAvbxlczjtSbveJGb32 1233452695
Date: Sat, 31 Jan 2009 23:44:53 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manfred Wassmann <tux.wassmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw
	RAID partition + SMP
Message-ID: <20090201014453.GC22841@khazad-dum.debian.net>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com> <20090131134651.GC28763@khazad-dum.debian.net> <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com> <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Manfred Wassmann wrote:
> It is a 3ware 9650SE initially supplied with a firmware version FE9X
> 3.08.00.029 but the problem remained after an upgrade to the current
> version 4.06.00.004

Search the list archives, there are other problem reports for that
3ware card, you probably want to check those.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
