Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZD1NvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZD1NvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZD1NvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:51:09 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38478 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZD1NvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:51:09 -0400
Subject: Re: [PATCH] Remove extra semicolon from if() in
 drivers/regulator/core.c
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: mika.kukkonen@nokia.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090428071751.GA25645@nokia.com>
References: <20090428071751.GA25645@nokia.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:51:06 +0100
Message-Id: <1240926666.14165.148.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 10:17 +0300, Mika Kukkonen wrote:
> In function drms_uA_update() in file drivers/regulator/core.c there is a tailing semicolon
> in the end of if() condition which causes the function in question to return unconditionally.
> Remove it to enable rest of the code in the function.
> 
> Signed-off-By: Mika Kukkonen <mika.kukkonen@nokia.com>
> 

Thanks. Applied a patch for this recently, will be issuing pull request
tonight.

Liam

