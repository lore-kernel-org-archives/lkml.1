Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYEUBpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYEUBpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYEUBpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:45:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37634 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784AbYEUBpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:45:02 -0400
X-Sasl-enc: qmxVwWmplnzygHIaWtGInI+iOWeywIsPX3FmV9/X/x97 1211334301
Date: Tue, 20 May 2008 22:44:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions
Message-ID: <20080521014458.GB26427@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805201209.08986.IvDoorn@gmail.com> <1211298846.8328.1254165905@webmail.messagingengine.com> <200805201918.58709.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805201918.58709.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Ivo van Doorn wrote:
> > Then, in that future patch, we change the API, fix all in-tree drivers using
> > that API, and update the documentation to match the new API.  For now, we
> > update the documentation to match the current API.
> > 
> > What do you think?
> 
> Sounds good to me. :)

I'll take that as an ACK :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
