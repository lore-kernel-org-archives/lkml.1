Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYJOJFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYJOJFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYJOJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:05:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33158 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbYJOJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:05:27 -0400
Date: Wed, 15 Oct 2008 10:05:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kaz Kylheku" <kkylheku@gmail.com>
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary
 driver.
Message-ID: <20081015100521.739277f2@lxorguk.ukuu.org.uk>
In-Reply-To: <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
	<48F5193B.1010601@nortel.com>
	<3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But thanks to the gracious tolerance of the kernel development
> community, such drivers are permitted to exist. That is the question:

Thats an interesting interpretation and not one I'd want to rely upon.

> setting aside GPL chapter and verse, could that tolerance extend
> to allow such a driver to get a piece of boot-time memory, and if so,
> what mechanism would be tolerated?

You should discuss such matters with your lawyer. What you are trying to
ask I think is a question about what constitutes an independant work, and
that is a legal not a technical question.

Alan
