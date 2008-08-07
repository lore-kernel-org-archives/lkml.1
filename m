Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYHGSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYHGSCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYHGSCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:02:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHGSCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:02:42 -0400
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
From: Andi Kleen <andi@firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	<1218100464.8625.9.camel@twins>
	<1218105597.15342.189.camel@think.oraclecorp.com>
Date: Thu, 07 Aug 2008 20:02:39 +0200
In-Reply-To: <1218105597.15342.189.camel@think.oraclecorp.com> (Chris Mason's message of "Thu, 07 Aug 2008 06:39:57 -0400")
Message-ID: <877ias66v4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:
>
> Metadata is duplicated by default even on single spindle drives, 

Can you please say a bit how much that impacts performance? That sounds 
costly.

-Andi
