Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYGJB1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYGJB1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGJB1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:27:42 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:32991 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYGJB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:27:41 -0400
X-Sasl-enc: f7E41dwFk/fXmAwuZkFUnArHRgn8tXHIal436+j4IVC1 1215653259
Date: Wed, 9 Jul 2008 22:27:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Gerhard Wiesinger <lists@wiesinger.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Message-ID: <20080710012736.GD15729@khazad-dum.debian.net>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern> <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan> <alpine.LFD.1.10.0807081232350.32659@bbs.intern> <alpine.DEB.1.10.0807080915040.23688@p34.internal.lan> <alpine.LFD.1.10.0807090726200.686@bbs.intern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807090726200.686@bbs.intern>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008, Gerhard Wiesinger wrote:
> Load on power supply measured on 220V side with a true RMS Wattmeter:

That won't help for the failure mode you're looking for.

Hook an osciloscope to the power lines on the HD's power feed, and try to
get it to trigger on any "big" variations.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
