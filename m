Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbYESWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbYESWFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbYESWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:04:26 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49448 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763645AbYESWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:04:24 -0400
X-Sasl-enc: 2van5BSTPxJdycbG+wUrw3IQzZV0q6MbXJkKdOhVJerK 1211234662
Date: Mon, 19 May 2008 19:04:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       Thomas Renninger <trenn@suse.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions
Message-ID: <20080519220419.GA3369@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-16-git-send-email-hmh@hmh.eng.br> <20080519105108.8f843c47.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519105108.8f843c47.randy.dunlap@oracle.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Randy Dunlap wrote:
> Add INTRODUCTION item here?

Will do, for completeness if anything.

[snip]

> > +Add the SW_* events you need them for switches, do NOT try to emulate a button
> 
> Delete "them"?  A little misworded/confusing.

Yeah, I somehow lost part of that sentence while editing the file or
somesuch.

> > +******IMPORTANT******
> > +When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE OF A RFKILL
> 
> OF AN RKFILL ?
> i.e., does one say "R F KILL" or does one say "rifkill" or "rufkill" or
> something else?

I have no idea :(   I'd read it as if I were spelling "R" "F", so I
think it should be an "AN".

Thanks for the corrections.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
