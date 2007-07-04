Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbXGDLN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbXGDLN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbXGDLLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:11:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:25663 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761979AbXGDLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:11:12 -0400
Date: Wed, 4 Jul 2007 13:11:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Karel Zak <kzak@redhat.com>
cc: List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
In-Reply-To: <20070703221156.GY14825@petra.dvoda.cz>
Message-ID: <Pine.LNX.4.64.0707041308330.1536@fbirervta.pbzchgretzou.qr>
References: <20070703221156.GY14825@petra.dvoda.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 4 2007 00:11, Karel Zak wrote:
>newgrp:
>	add support for /etc/gshadow
>	check result from getgrnam() more carefully

Hm, gshadow looks like it is really obsolete. (There is no such file anymore in
suse releases since a long while. Previously, gshadow was filled with all the
groups that existed.)


	Jan
-- 
