Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZHLWV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZHLWV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZHLWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:21:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:57391 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752187AbZHLWV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:21:56 -0400
Date: Wed, 12 Aug 2009 18:21:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: System freeze on reboot - general protection fault
In-Reply-To: <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0908121820410.3257@gentwo.org>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>  <alpine.DEB.1.10.0908111032110.30494@gentwo.org>  <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com>  <alpine.DEB.1.10.0908111056550.30494@gentwo.org> 
 <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>  <20090811154853.GF2763@sgi.com>  <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com> <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Zdenek Kabelac wrote:

> > I've added authors of some recent conntrack commits to Cc: - maybe
> > they might know?
>
> I've tested v2.6.30 - and it's crashing in the same way - so any other
> starting point where slub has the same detection mechanism and
> conntrack module should be working reliable ?

Next point is 2.6.29.

