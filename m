Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZJZTGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZJZTGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZJZTGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:06:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:40007 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbZJZTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:06:52 -0400
In-Reply-To: <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com> <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <E1A2BB8B-F291-4C9E-B095-39F0AE7A0587@noahdesu.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, noah@noahdesu.com
Content-Transfer-Encoding: 7bit
From: Noah Watkins <noah@noahdesu.com>
Subject: Re: Difference between atomic operations and memory barriers
Date: Mon, 26 Oct 2009 12:07:27 -0700
To: "Leonidas ." <leonidas137@gmail.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So we can safely assume that pointer assignment will be done in an
> atomic manner?

See the the comment above rcu_assign_pointer in
include/linux/rcupdate.h

-noah

> -Leo.

