Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZAEUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZAEUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZAEUzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:55:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43343 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZAEUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:55:09 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: A SuSE riddle
From: Andi Kleen <andi@firstfloor.org>
References: <20090105185225.GH6165@tatooine.rebelbase.local>
Date: Mon, 05 Jan 2009 21:55:05 +0100
In-Reply-To: <20090105185225.GH6165@tatooine.rebelbase.local> (markus reichelt's message of "Mon, 05 Jan 2009 19:52:25 +0100")
Message-ID: <874p0do4ly.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt <ml@mareichelt.de> writes:

> this goes out to the SusE folks in here: 
>
> What the heck is needed to get one's hands on the contents of
>
> kernel-source-2.6.27.7-9.1.i586.rpm

Since 11.0 SUSE uses LZMA enabled rpm, so you need rpm or rpm2cpio
versions that support that.

-Andi
-- 
ak@linux.intel.com
