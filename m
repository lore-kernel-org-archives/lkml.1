Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZALUrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZALUrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZALUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:47:27 -0500
Received: from yop.chewa.net ([91.121.105.214]:51812 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZALUr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:47:26 -0500
From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Organization: Remlab.net
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: RFC: Network privilege separation.
Date: Mon, 12 Jan 2009 22:47:21 +0200
User-Agent: KMail/1.9.9
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901122230.25976.rdenis@simphalempin.com> <20090112205547.GE23848@one.firstfloor.org>
In-Reply-To: <20090112205547.GE23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901122247.22059.rdenis@simphalempin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 janvier 2009 22:55:47 Andi Kleen, vous avez écrit :
> Fair point, although I'm afraid you didn't do a very good
> job explaining your reasons, so it sounds like a
> quite arbitary decision.

Fair enough. It's just way too much interface/adaptation work compared to the 
benefit. Especially considering that it would be much easier, and almost as 
secure, with a "relaxed" SECCOMP. And on top of that, it's causing 
unnecessary overhead (we're also interested in those small Linux-based 
handsets that aren't as fast and power-hungry as desktop PCs).

-- 
Rémi Denis-Courmont
http://www.remlab.net/
