Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbXLTSMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbXLTSMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763503AbXLTSMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:12:41 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:63878 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763060AbXLTSMk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:12:40 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Thu, 20 Dec 2007 19:12:37 +0100
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <476A8965.40703@s5r6.in-berlin.de>
In-Reply-To: <476A8965.40703@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712201912.37416.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 20. Dezember 2007, you wrote:
> Hemmann, Volker Armin wrote:
> > [ 5194.131014] Pid: 22490, comm: sleep Tainted: P        2.6.23.11reiser4
> > #4
>
> The subject line is wrong.
> You apparently run Linux, but not Linux 2.6.23.y.

first of all, apart from this oops all other oopses I reported were with a 
not-tainted kernel. You might want to read the other mails I have sent.

Also, besides of the reiser4 patch there is no other patch added to the 
kernel. And since people have had  successfully reported problems with 
heavily distro-patched kernels in the past it looks a little bit hypocritical 
to put my reports aside because of one single patch - don't you think?

Glück Auf,
Volker
