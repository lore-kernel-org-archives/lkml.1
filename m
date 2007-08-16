Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbXHPALk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbXHPALk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXHPALc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:11:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46204 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbXHPALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:11:30 -0400
Subject: Re: dual Xeon hyperthread system only showing up as 2 cpus
From: Arjan van de Ven <arjan@infradead.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46C3897A.6060106@nortel.com>
References: <46C3897A.6060106@nortel.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 15 Aug 2007 17:07:28 -0700
Message-Id: <1187222848.2533.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Anyone have any ideas?

you don't appear to have ACPI enabled... how does 2.6.22 or 2.6.23-rc
fare?


