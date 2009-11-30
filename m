Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZK3Nw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZK3Nw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZK3Nw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:52:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55056 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbZK3Nw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:52:27 -0500
Date: Mon, 30 Nov 2009 13:54:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: William Allen Simpson <william.allen.simpson@gmail.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
Message-ID: <20091130135435.3895a437@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130134414.GB7114@ff.dom.local>
References: <4B13A025.7000103@gmail.com>
	<20091130134414.GB7114@ff.dom.local>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Miller (with Perches) changed hundreds (thousands?) of these to
> > trailing form.  This results in a number of hilarious examples --
> > lines with both leading and trailing, lines with only &&, etc.  A
> > small sample for illustration:
> 
> Yes, it's even enough to make a grown man laugh....

IMHO for left to right languages dangly bits want to be on the right,
because that is where your eyes are when you hit the end of the previous
line, so the dangly bit is already in your line of vision and probably
even in focus.

