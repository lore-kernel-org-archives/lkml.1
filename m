Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYD2MBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYD2MBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYD2MBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:01:12 -0400
Received: from stinky.trash.net ([213.144.137.162]:51483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYD2MBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:01:12 -0400
Message-ID: <48170E04.3020704@trash.net>
Date: Tue, 29 Apr 2008 14:01:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: "Denis V. Lunev" <den@openvz.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 11/12] netfilter: assign PDE->data before gluing PDE into
 /proc tree
References: <1209467538.29647.11.camel@iris.sw.ru> <1209467602-20001-11-git-send-email-den@openvz.org>
In-Reply-To: <1209467602-20001-11-git-send-email-den@openvz.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis V. Lunev wrote:
> Replace proc_net_fops_create with proc_create_data.
>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> Cc: Alexey Dobriyan <adobriyan@openvz.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Patrick McHardy <kaber@trash.net>

For the VLAN and netfilter patches:

Acked-by: Patrick McHardy <kaber@trash.net>

