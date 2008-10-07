Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYJGVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYJGVz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYJGVzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:55:50 -0400
Received: from gw.goop.org ([64.81.55.164]:60222 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYJGVzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:55:50 -0400
Message-ID: <48EBDAA9.4080208@goop.org>
Date: Tue, 07 Oct 2008 14:54:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 deadlocks
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net> <48EBD448.1010309@redhat.com>
In-Reply-To: <48EBD448.1010309@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> ok I can reproduce this too.  I'm guessing this is a migrated ext3
> filesystem?
>   

Yes.  I just used tune2fs on it to enable extents.

> I'll sort out a fix soon.
>
>   

Thanks,
    J
