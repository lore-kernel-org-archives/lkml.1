Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYAYRhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYAYRhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYAYRhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:37:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYAYRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:37:31 -0500
Date: Fri, 25 Jan 2008 18:37:23 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: <Pine.LNX.4.64.0801251603380.15243@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.0.999.0801251836420.2201@be1.lrz>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
 <Pine.LNX.4.64.0801251603380.15243@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+rdNTBeffYxjcLcxy2cLdhiP6wQRNLZ+/9EkW
 T16KcVjnpC5RW1D7vNsXS9RgZtsm42VHfuUQEVelMjeRpDqhKv
 j0hff+FATFTgP2WdFDuJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Jan Engelhardt wrote:
> On Jan 25 2008 15:54, Bodo Eggert wrote:

> >+#ifdef SOFTPANIC
> 
> #ifdef CONFIG_SOFTPANIC?

Thanks. I remember having fixed it ...
-- 
Professionals are predictable, it's the amateurs that are dangerous.
