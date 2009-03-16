Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbZCPObQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbZCPObQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZCPOa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:30:58 -0400
Received: from stinky.trash.net ([213.144.137.162]:46673 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbZCPOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:30:58 -0400
Message-ID: <49BE629E.9080604@trash.net>
Date: Mon, 16 Mar 2009 15:30:54 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Scott James Remnant <scott@canonical.com>
CC: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 05/31] netfilter: Auto-load ip6_queue module when socket
 opened.
References: <cover.1236702228.git.scott@canonical.com> <1ac10308df52b2e58c3a77313d3608c1a130341f.1236702228.git.scott@canonical.com>
In-Reply-To: <1ac10308df52b2e58c3a77313d3608c1a130341f.1236702228.git.scott@canonical.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> The ip6_queue module is missing the net-pf-16-proto-13 alias that would
> cause it to be auto-loaded when a socket of that type is opened.  This
> patch adds the alias.

Applied, thanks.
