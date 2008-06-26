Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYFZQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYFZQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYFZQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:00:27 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36214 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYFZQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:00:26 -0400
Message-ID: <4863BD15.302@s5r6.in-berlin.de>
Date: Thu, 26 Jun 2008 18:00:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Tomas M <tomas@slax.org>
CC: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
References: <48634BA7.6030902@slax.org> <alpine.LNX.1.10.0806261430470.12725@fbirervta.pbzchgretzou.qr> <48639B88.1020704@slax.org>
In-Reply-To: <48639B88.1020704@slax.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas M wrote:
>> The bad thing is, they won't tell you before you submitted it.
> 
> By 'they' you mean who?
> Who decides what is accepted anyway?

Major contributors (reviewers, maintainers) do, and ultimately Linus.

You said LZMA is already used by out-of-tree code in the embedded
domain.  So I suppose a submission of an LZMA implementation should
rather be part of a submission of code which actually uses it.
-- 
Stefan Richter
-=====-==--- -==- ==-=-
http://arcgraph.de/sr/
