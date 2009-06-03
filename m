Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZFCTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZFCTXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZFCTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:23:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59304 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZFCTXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:23:05 -0400
Date: Wed, 3 Jun 2009 21:25:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] kbuild: some scripts/config improvements (try 2)
Message-ID: <20090603192520.GC3100@uranus.ravnborg.org>
References: <20090525144320.GA22686@sepie.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525144320.GA22686@sepie.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 04:43:20PM +0200, Michal Marek wrote:
> Hi,
> 
> I simplified the awk script a bit, made it awk ... && mv and removed the
> --set option.
> 
> Michal Marek (3):
>   kbuild: handle non-existing options in scripts/config
>   kbuild: simplify argument loop in scripts/config
>   kbuild: add generic --set-str option to scripts/config

Andi - do I have your ack on this serie?

	Sam
