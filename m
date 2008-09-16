Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYIPReQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYIPReQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYIPReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:34:00 -0400
Received: from gw.goop.org ([64.81.55.164]:54372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYIPReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:34:00 -0400
Message-ID: <48CFEE07.1010609@goop.org>
Date: Tue, 16 Sep 2008 10:33:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6 xen soft lockup
References: <48C7BB39.6090700@xs4all.nl> <48C7FB83.8080904@goop.org> <48C81537.8080409@xs4all.nl> <48C81F12.9040208@goop.org> <48C83546.7090206@xs4all.nl>
In-Reply-To: <48C83546.7090206@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> dmesg output attached.
>
> thanks for looking into it.

It looks like this isn't Xen-specific at all.  See
http://www.kerneloops.org/searchweek.php?search=native_safe_halt

    J
