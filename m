Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0BOWT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:19:28 -0500
Received: from mail001.aei.ca ([206.123.6.130]:51701 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab0BOWT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:19:26 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Chris Mason <chris.mason@oracle.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: Re: [LOCKING] 2.6.33-rc8 btrfs vs java
Date: Mon, 15 Feb 2010 17:19:22 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.32.8-crc; KDE/4.4.0; x86_64; ; )
References: <201002141914.50955.edt@aei.ca> <20100215155653.GC11057@think>
In-Reply-To: <20100215155653.GC11057@think>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151719.22956.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010 10:56:53 Chris Mason wrote:
> On Sun, Feb 14, 2010 at 07:14:50PM -0500, Ed Tomlinson wrote:
> > Hi,
> > 
> > Found this in my log for 2.6.33-rc8.  Figgured it might be interesting since .33 is close.
> 
> The btrfs tree locking is very tricky for lockdep.  I don't quite see
> how you could hit this one without also deadlocking the machine, unless
> it is a false positive.
> 
> So, did you deadlock the machine? ;)

No.  So maybe its a false positive?

Ed
