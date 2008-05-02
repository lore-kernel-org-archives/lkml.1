Return-Path: <linux-kernel-owner+w=401wt.eu-S937341AbYEBWuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937341AbYEBWuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937271AbYEBWuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:50:23 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48746 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936375AbYEBWuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:50:22 -0400
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: HELP:  Is writeq an atomic operation??
From: Andi Kleen <andi@firstfloor.org>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
Date: Sat, 03 May 2008 00:50:12 +0200
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com> (Eric Moore's message of "Fri, 2 May 2008 16:40:40 -0600")
Message-ID: <87y76stj6j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 22:43:17.0730 (UTC) FILETIME=[EA1B5420:01C8ACA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Moore, Eric" <Eric.Moore@lsi.com> writes:

> Here is a trace from pci express analyzer.   I'm sending

With what CPU/chipset was that?

-Andi
