Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGNJQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGNJQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZGNJQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:16:52 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:49234 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753525AbZGNJQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:16:52 -0400
X-Sender-Authentication: net64
Date: Tue, 14 Jul 2009 11:16:47 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090714111647.5759d439.skraw@ithnet.com>
In-Reply-To: <4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 22:40:39 -0700
Jesse Brandeburg <jesse.brandeburg@gmail.com> wrote:

> [...]
> are you running jumbo frames perhaps?

there are no jumbo frames involved in this problem. All we do here is to rsync around a dozen hosts to the box in question.
Btw, there are _three_ e1000e inside this box:

01:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
0d:00.0 Ethernet controller: Intel Corporation 82573V Gigabit Ethernet Controller (Copper) (rev 03)
0f:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller

-- 
Regards,
Stephan
