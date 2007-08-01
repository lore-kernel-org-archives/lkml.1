Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXHASa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXHASa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbXHASaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:30:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35492 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbXHASaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:30:19 -0400
Date: Wed, 1 Aug 2007 20:30:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@novell.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Deprecate a.out ELF interpreters
In-Reply-To: <200708011433.09433.ak@novell.com>
Message-ID: <Pine.LNX.4.64.0708012029130.26668@fbirervta.pbzchgretzou.qr>
References: <200708011433.09433.ak@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1 2007 14:33, Andi Kleen wrote:
>Comments?

A kconfig entry "(OBSOLETE)"/"(DEPRECATED)" would be nice.
(And if you want to test people, 'depends on EMBEDDED' for CONFIG_BINFMT_AOUT)


	Jan
-- 
