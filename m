Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZEUWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZEUWkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZEUWkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:40:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbZEUWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:40:24 -0400
Date: Thu, 21 May 2009 18:39:59 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: What happened to the dynamic_printk boot option?
Message-ID: <20090521183959.7a18bad8@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic_printk boot option is still listed in kernel-parameters.txt
but it's gone from the kernel and I can't find any replacement for
enabling dynamic debug messages at boot time any more.
