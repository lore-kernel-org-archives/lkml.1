Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZHNJSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZHNJSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZHNJSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:18:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:45505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZHNJR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:17:59 -0400
Message-ID: <4A852BC0.1090404@kernel.org>
Date: Fri, 14 Aug 2009 18:17:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org>
In-Reply-To: <h63737$b2a$1@ger.gmane.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 09:17:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
> hi all,
> 
> running 2.6.31-rc5 (7cb7beb31aa3d941833b6a6e553687422c31e4b6 to be
> exact), sometimes some hard disks don't show up.
> 
> after booting, my root hd (sda) is mounted to /, while two other hds
> (sdb/sdc) are mounted as a user. sda is always present, but the other
> two sometimes don't show up (i.e. they are not listed in /dev/disk/, nor
> to they have a /dev/sdX link). with 2.6.29 and 2.6.30, all three disks
> are reported correctly.

Can you please attach boot logs of a successful and a failed boot?

Thanks.

-- 
tejun
