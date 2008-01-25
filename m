Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYAYPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYAYPVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYAYPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:21:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53253 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYAYPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:21:08 -0500
Date: Fri, 25 Jan 2008 16:21:07 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce softpanic
In-Reply-To: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
Message-ID: <Pine.LNX.4.64.0801251603380.15243@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 15:54, Bodo Eggert wrote:
>+#ifdef SOFTPANIC

#ifdef CONFIG_SOFTPANIC?

