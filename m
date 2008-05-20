Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbYETS7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbYETS7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYETS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:59:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbYETS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:59:46 -0400
Message-ID: <48331FA0.9000000@firstfloor.org>
Date: Tue, 20 May 2008 20:59:44 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@infradead.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080520528.793382059@firstfloor.org>	<20080520152843.CF4181B4205@basil.firstfloor.org>	<20080520085830.22c99115@infradead.org> <20080520193314.061f0c24@core>
In-Reply-To: <20080520193314.061f0c24@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Agreed entirely - all our unlocked_foo methods we got stuck with,

That's the goal actually to "get stuck with it" and ->fasync going
away.

-Andi
