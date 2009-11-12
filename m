Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZKLRvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZKLRvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZKLRvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:51:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753326AbZKLRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:51:01 -0500
Date: Thu, 12 Nov 2009 17:52:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112175242.135366aa@lxorguk.ukuu.org.uk>
In-Reply-To: <1258042007.31158.1344897055@webmail.messagingengine.com>
References: <4AFACC03.7080209@mayc.ru>
	<4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
	<20091112110949.339c0c64@lxorguk.ukuu.org.uk>
	<1258042007.31158.1344897055@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Any forensics person who images /dev/mem needs to go back to school.
> 
> While I do agree with you, I can assure you they do it all the time at
> least around here, and it is still listed as "best practice" in the
> notebooks of many.

Oh dear me. Well the purpose of the kernel isn't to provide an idiot
filter, that is what the security policies and not giving people root is
for.

You have a people problem. Technical fixes to people problems rarely work.
