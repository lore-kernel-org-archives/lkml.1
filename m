Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYCOD1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYCOD1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYCOD07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:26:59 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:54523 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCOD07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:26:59 -0400
Date: Sat, 15 Mar 2008 04:18:39 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 8/8] handle leap second via timer
In-Reply-To: <1205526244.6122.5.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150417540.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195737.212526899@linux-m68k.org> <1205526244.6122.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> Instead of exporting the clocksource making it global, could you use a
> timekeeping_insert/remove_second() style interface?

Sounds good.

bye, Roman
