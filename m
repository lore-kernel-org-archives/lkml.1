Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbXGYVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbXGYVGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXGYVGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:06:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957AbXGYVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:06:05 -0400
Date: Wed, 25 Jul 2007 14:04:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Kirill Korotaev <dev@openvz.org>,
       Masoud Asgharifard Sharbiani <masouds@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
Message-Id: <20070725140455.cbbc0dde.akpm@linux-foundation.org>
In-Reply-To: <200707251657.44217.ak@suse.de>
References: <20070718154759.GA26425@google.com>
	<46A76210.5020903@openvz.org>
	<200707251657.44217.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 16:57:43 +0200
Andi Kleen <ak@suse.de> wrote:

> On Wednesday 25 July 2007 16:45, Kirill Korotaev wrote:
> > plz don't enable it by default... :/
> > any user can spam syslog with these messages and if syslog is run as root
> > can take the whole diskspace...
> 
> There are plenty of other ways to cause syslog messages anyways;

tell us what they are and we'll fix them?

> this argument is 100% bogus.

people don't like leaving themselves open to logspamming.


For this particular issue: someone please send a patch.
