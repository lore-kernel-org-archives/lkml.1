Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXHCQCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXHCQCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759668AbXHCQCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:02:00 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:52812 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023AbXHCQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:02:00 -0400
Date: Fri, 3 Aug 2007 12:01:49 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Ben Collins <ben.collins@ubuntu.com>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit kernel
In-Reply-To: <1186156713.8105.76.camel@cunning>
Message-ID: <Pine.LNX.4.64.0708031159440.3978@lancer.cnet.absolutedigital.net>
References: <1186150484.8105.57.camel@cunning>  <1186155056.2707.0.camel@laptopd505.fenrus.org>
  <1186155828.8105.69.camel@cunning>  <Pine.LNX.4.64.0708031146090.3978@lancer.cnet.absolutedigital.net>
 <1186156713.8105.76.camel@cunning>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Ben Collins wrote:

> nolapic_timer does not fix it for me. Only nolapic and acpi=off works. I
> commented on that thread as well now, thanks.

Interesting. However, I don't have NO_HZ so maybe that plays on it...

-- 
Cal Peake

