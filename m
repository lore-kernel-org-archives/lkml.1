Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbXFOJBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbXFOJBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXFOJB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:01:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:20161 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbXFOJBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:01:25 -0400
Date: Fri, 15 Jun 2007 11:01:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: markus reichelt <ml@mareichelt.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/loop* devices not appearing in /dev (at least since
 2.6.22-rc3*)
In-Reply-To: <20070614125224.GA4155@tatooine.rebelbase.local>
Message-ID: <Pine.LNX.4.64.0706151101070.32724@fbirervta.pbzchgretzou.qr>
References: <e85b9d30706140437s5f3622c3rc86c75a4f845e7a3@mail.gmail.com>
 <20070614125224.GA4155@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 14 2007 14:52, markus reichelt wrote:
>* Matthew <jackdachef@gmail.com> wrote:
>
>> I read that now loop devices are being created on demand, which
>> obviously (still) not works
>
>yes, someone thought this was a good idea :(

It *is* a good idea. MD works that way too.


	Jan
-- 
