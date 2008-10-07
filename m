Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYJGVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYJGVL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757888AbYJGVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:11:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57191 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757886AbYJGVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:11:06 -0400
X-Sasl-enc: XBSOnwFYYT0nEDVgfSKbs7+aL5L1VhN0ssqKjuqcMRCn 1223413864
Date: Tue, 7 Oct 2008 18:11:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
Message-ID: <20081007211101.GA20648@khazad-dum.debian.net>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman> <20081007185846.GA6604@elf.ucw.cz> <20081007192112.GL13035@tekkaman> <20081007195648.GD6604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007195648.GD6604@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Oct 2008, Pavel Machek wrote:
> In fact, thinkpad light should probably behave like that, too...

It is supposed to, and actually does so in my T43 without any extra help :-)

But if it doesn't in your ThinkPad, thinkpad-acpi does export a LED
interface for the ThinkLight and this new tigger will fix it for you right
away :p

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
