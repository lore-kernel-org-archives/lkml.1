Return-Path: <linux-kernel-owner+w=401wt.eu-S2992794AbXBIT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992794AbXBIT6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423284AbXBIT6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:58:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423258AbXBIT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:58:14 -0500
Date: Fri, 9 Feb 2007 11:54:26 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: "D. Hazelton" <dhazelton@enter.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: somebody dropped a (warning) bomb
Message-Id: <20070209115426.9a792e5c.zaitcev@redhat.com>
In-Reply-To: <200702082227.43373.dhazelton@enter.net>
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
	<200702082227.43373.dhazelton@enter.net>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 22:27:43 -0500, "D. Hazelton" <dhazelton@enter.net> wrote:

> So almost all the rules around the signs of types are because of a single, 
> historical machine. Hence the rules about "char" being unsigned by default 
> and "int" being signed by default are because of the nature of the PDP-11. 
>[...]
> Now: There is no reason for the behavior that came from the nature of the 
> PDP11 to have survived, but because it was in "The White Book" it made it 
> through the ANSI standardization process.
> 
> Now that this history lesson is over...

... we can remember that char is signed on PDP-11. Mvu hah hah hah ha,
only serious. Check how movb works.

-- Pete
