Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbXAVUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbXAVUph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbXAVUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:45:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52731 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbXAVUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:45:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45B52240.6010409@s5r6.in-berlin.de>
Date: Mon, 22 Jan 2007 21:44:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [-mm patch] drivers/firewire/: cleanups
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070122181736.GU9093@stusta.de> <45B51369.1060408@redhat.com> <20070122200423.GA9093@stusta.de> <45B518E4.5040104@redhat.com>
In-Reply-To: <45B518E4.5040104@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Adrian Bunk wrote:
>>>> This patch contains the following cleanups:
>>>> - "extern inline" -> "static inline"
>>>> - fw-topology.c: make struct fw_node_create static

Committed to linux1394-2.6.git.
-- 
Stefan Richter
-=====-=-=== ---= =-==-
http://arcgraph.de/sr/
