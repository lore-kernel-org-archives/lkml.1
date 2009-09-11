Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZIKHcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZIKHcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZIKHcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:32:12 -0400
Received: from relay.atmel.no ([80.232.32.139]:65482 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZIKHcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:32:12 -0400
Date: Fri, 11 Sep 2009 09:31:26 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 09/10] avr32: Convert BUG() to use unreachable()
Message-ID: <20090911093126.171d576b@hskinnemoen-d830>
In-Reply-To: <1252627011-2933-9-git-send-email-ddaney@caviumnetworks.com>
References: <4AA991C1.1050800@caviumnetworks.com>
	<1252627011-2933-9-git-send-email-ddaney@caviumnetworks.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney@caviumnetworks.com> wrote:
> Use the new unreachable() macro instead of for(;;);
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> CC: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
