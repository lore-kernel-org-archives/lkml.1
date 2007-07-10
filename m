Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXGJOZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXGJOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXGJOZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:25:21 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:45862 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXGJOZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:25:20 -0400
Message-ID: <46939561.4070100@openvz.org>
Date: Tue, 10 Jul 2007 18:19:13 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 0/3] Parts of pid namespaces approved by all the
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were acked by all the people who is interested in
having pid namespace in the kernel and proposed for inclusion.
Made against 2.6.22-rc6-mm1 and checked on i386 and x86_64 nodes.

[PATCH 1/3] - Api rename.
              Acked by Cedric Le Goater.
[PATCH 2/3] - Small improvement of get_pid_ns() call.
              Acked by Cedric.
[PATCH 3/3] - Kmem caches for infinite namespaces nesting.
              Acked by Cedric and Sukadev Bhattiprolu.
