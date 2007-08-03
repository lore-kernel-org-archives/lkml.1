Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXHCPoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXHCPoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbXHCPnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:43:55 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:41175 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXHCPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:43:54 -0400
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit
	kernel
From: Ben Collins <ben.collins@ubuntu.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <1186155056.2707.0.camel@laptopd505.fenrus.org>
References: <1186150484.8105.57.camel@cunning>
	 <1186155056.2707.0.camel@laptopd505.fenrus.org>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 03 Aug 2007 11:43:48 -0400
Message-Id: <1186155828.8105.69.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-03 at 08:30 -0700, Arjan van de Ven wrote:
> > I've tried every combination of boot param revolving around clocksource
> > and interrupts. The only thing that gets me booting is nolapic, but then
> > again, that knocks me down to a single cpu. 
> 
> hummm.... I wonder how nolapic knows you down to a single cpu.......
> that is just an entirely strange relationship.

Sorry, s/cpu/core/, but not sure if that makes a difference.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

