Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYKQN6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYKQN6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYKQN55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:57:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYKQN54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:57:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081116162149.07f05c7c@kopernikus.site>
References: <20081116162149.07f05c7c@kopernikus.site> <1226846868-9595-1-git-send-email-bwalle@suse.de> <1226846868-9595-4-git-send-email-bwalle@suse.de> <20081116150901.4d824e6d@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bwalle@suse.de>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: [PATCH 3/3] Remove CONFIG_STRICT_DEVMEM
Date: Mon, 17 Nov 2008 13:57:38 +0000
Message-ID: <32168.1226930258@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bwalle@suse.de> wrote:

> For embedded users, do they use CONFIG_SYSCTL at all?

Yes.  It still allows you to configure various things about the kernel.

David
