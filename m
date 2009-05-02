Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZEBPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZEBPii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZEBPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:38:30 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49011 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbZEBPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:38:30 -0400
X-Sasl-enc: DsiCsMBrLHOre61gjgdQn+UDGQADmwxwoozJmKq4jY+p 1241278708
Date: Sat, 2 May 2009 12:38:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/88] 2.6.28.10-stable review
Message-ID: <20090502153826.GA1127@khazad-dum.debian.net>
References: <20090430170122.GA16015@kroah.com> <20090430214450.GC7174@khazad-dum.debian.net> <20090430215433.GG570@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430215433.GG570@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Willy Tarreau wrote:
> Why not stay on 2.6.27 if you need longer support ? I you really need some

I need something stable enough to not cause problems, and close enough
to latest mainline to not make backporting whatever I need for
thinkpad-acpi development a major chore.

Home server is already locked to 2.6.27.

> 2.6.28-specific features, it should not be *that* hard to incrementally
> apply next 2.6.27.X patchsets to your latest 2.6.28.Y, and this will leave
> you with some time to see 2.6.29 getting ready for your usage.

I think that's exactly what I will do, if needed.  Thanks for the
idea.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
