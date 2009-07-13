Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZGMOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZGMOP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZGMOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:15:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZGMOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:15:28 -0400
Subject: Re: Kernel Config Promt disabling
From: Peter Zijlstra <peterz@infradead.org>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <241b8f7b0907130304h3a3eec06w26fe8a2edfc3866e@mail.gmail.com>
References: <241b8f7b0907130304h3a3eec06w26fe8a2edfc3866e@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Jul 2009 16:15:26 +0200
Message-Id: <1247494526.7500.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 15:34 +0530, Prabhu Chawandi wrote:
> Hi,
> 
>   I am getting config promt to select options  all the time I build it.
> 
> How can I disable this prompting and telling it to take the status
> from current .config file ?

yes "" | make oldconfig
