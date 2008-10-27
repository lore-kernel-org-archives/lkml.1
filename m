Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbYJ0RRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbYJ0RRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0RRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:17:36 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:37266 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ0RRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:17:35 -0400
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in
	test_pages_isolated()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       y-goto@jp.fujitsu.com
In-Reply-To: <4905F114.3030406@de.ibm.com>
References: <4905F114.3030406@de.ibm.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 18:17:26 +0100
Message-Id: <1225127846.20384.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ouch, stupid Thunderbird broke the patch (or stupid me used Thunderbird...),
will send a new one.

Gerald


