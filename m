Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXIPRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXIPRJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXIPRJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:09:34 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1276 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXIPRJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:09:34 -0400
Date: Sun, 16 Sep 2007 19:10:06 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Matej Laitl <strohel@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another
 options and comments
In-Reply-To: <20070916111708.GA7362@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709161908050.1817@scrub.home>
References: <200709152004.11930.strohel@gmail.com> <20070916111708.GA7362@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 16 Sep 2007, Sam Ravnborg wrote:

> But can you take a look at distingushing between non-selectable options
> due to dependency issues and seleted-by symbols.

Do you have an example in mind? If a symbol is not changable, but still 
visible, a select is usually involved.

bye, Roman
