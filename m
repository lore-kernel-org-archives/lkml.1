Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZFOOkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZFOOkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZFOOj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:39:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:59906 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZFOOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:39:59 -0400
Subject: Re: [PATCH 0/2] Debug bits for the tty ldisc problem
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
References: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 16:39:56 +0200
Message-Id: <1245076796.6800.488.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 16:32 +0100, Alan Cox wrote:
> I'm not 100% sure the close one is
> safe for locking but as the lock detector has been busted since 2.6.30 its a
> bit hard to be sure.

Would you have some specifics?

