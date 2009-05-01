Return-Path: <linux-kernel-owner+w=401wt.eu-S1765726AbZEAAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765726AbZEAAaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764912AbZEAAHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:07:51 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46790 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765761AbZEAAHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:07:49 -0400
X-Sasl-enc: BFyv//Mlvi0VfvlooCprhYFI7kk/KpgRgAPXALSWBkEK 1241136469
Date: Thu, 30 Apr 2009 21:07:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/88] 2.6.28.10-stable review
Message-ID: <20090501000746.GD7174@khazad-dum.debian.net>
References: <20090430170122.GA16015@kroah.com> <20090430214450.GC7174@khazad-dum.debian.net> <20090430223212.GA16341@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430223212.GA16341@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Greg KH wrote:
> > and the fact that the queue for 2.6.29 isn't even empty yet and there are
> > already more patches waiting to get queued...
> 
> Yes there are, I will work on that next.  But I don't see anything
> "serious" in there that should be in the .28 kernel, do you?

No.

> Traditionally we've dropped the last -stable after the .2 release of the
> new series, why would we change that now?  We only have so much time to
> do this kind of work, and maintaining 3 -stable trees is a major pain,
> trust me...

I can imagine, and I have send you "your work is much appreciated mails"
before ;-)

> However, if you wish to take over 2.6.28 and maintain it after this
> release, I have no objection, just let me know.

No time :(  I wish I could, but I can't do it on paid time, and my hobby
time is already streched way too thin...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
