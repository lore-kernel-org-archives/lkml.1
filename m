Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZC0J2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZC0J2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZC0J2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:28:13 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:33412 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbZC0J2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:28:12 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net B20C01B3E20
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: TOMOYO in linux-next
To: Pavel Machek <pavel@ucw.cz>, James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 27 Mar 2009 10:28:07 +0100
References: <ck5CF-5mU-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Ln8MC-0001RR-1E@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> I don't think merging that is good idea. Security should be doable
> without making shell-like glob matching...

How do you suppose a security system should handle mozilla modifying
~/.bashrc differently from downloading something to ~/pr0n.jpg?


