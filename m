Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbXJKARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbXJKARy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXJKARs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:17:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41839 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXJKARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:17:47 -0400
Date: Thu, 11 Oct 2007 02:17:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Russ Dill <Russ.Dill@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [OT] Argument with an OS professor over profile=3
In-Reply-To: <loom.20071011T001229-285@post.gmane.org>
Message-ID: <Pine.LNX.4.64.0710110217140.26305@fbirervta.pbzchgretzou.qr>
References: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
 <loom.20071011T001229-285@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 00:13, Russ Dill wrote:
>
>                /* only text is profiled */
>>                 prof_len = (unsigned *) &_etext - (unsigned *) &_stext;

Uh, that's some evil pointer arithmetic :)
