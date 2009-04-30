Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbZD3ObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbZD3ObU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZD3ObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:31:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51009 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbZD3ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:31:09 -0400
X-Sasl-enc: q93Ebi59+cIVs8g+y+ARNKL7vOpqeZx/wNzcDq8r+Csu 1241101868
Date: Thu, 30 Apr 2009 11:31:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mao Yilu <ylmao@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TSC unstable on Intel Pentium M processor 750
Message-ID: <20090430143105.GD28027@khazad-dum.debian.net>
References: <440758024.12507@ustc.edu.cn> <441049102.10204@ustc.edu.cn> <654E14825BCE4C9B94E5986000DC9BCE@xiaomao> <441061189.03958@ustc.edu.cn> <70DF5CB591F94B45BBC9BD2D41A047EF@xiaomao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70DF5CB591F94B45BBC9BD2D41A047EF@xiaomao>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Mao Yilu wrote:
> > On Thu, 30 Apr 2009, Mao Yilu wrote:
> > > But I still don't know why the TSC is not correct in the C1 state (hlt
> > > instruction). Is there anything more to influence the TSC? What happened
> > > when the CPU is not running under hlt instruction?
> > 
> > SMIs?  Laptops love that crap...
> 
> What is SMIs?

http://en.wikipedia.org/wiki/System_Management_Mode

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
