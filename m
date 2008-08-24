Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYHXAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYHXAYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYHXAYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 20:24:05 -0400
Received: from main.gmane.org ([80.91.229.2]:57621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYHXAYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 20:24:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sergey Spiridonov <sena@hurd.homeunix.org>
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363  (JMB363)
   kernel 2.6.25-2 Debian/Lenny
Date: Sun, 24 Aug 2008 02:27:41 +0200
Message-ID: <g8q9mg$v2p$1@ger.gmane.org>
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.234.202.175
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
In-Reply-To: <48B0916C.4080805@garzik.org>
X-Enigmail-Version: 0.94.2.0
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Jeff Garzik wrote:

> So...  suspect bad cables, bad port connectors, cable interference,
> motherboard-caused interference or grounding problems, power supply
> problems.

I did exchange power supply and I did exchange hard drives. The same
hard drive with the same cable works with SB600 and produces errors with
JMB363. So looks like it is not cable or hard drive problem. May be the
problem is JMB363 port connector on the motherboard. How can I check it?
-- 
Best regards, Sergey Spiridonov

