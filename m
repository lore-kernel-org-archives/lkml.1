Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYHMHaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYHMHaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYHMHaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:30:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54424 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYHMHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:30:08 -0400
Message-ID: <48A28CAB.3080803@cs.helsinki.fi>
Date: Wed, 13 Aug 2008 10:26:35 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 14/19] Filesystem: Ext4 filesystem defrag
References: <20080801182324.572058187@lameter.com> <20080801182347.191898393@lameter.com> <20080803015404.GC11488@mit.edu>
In-Reply-To: <20080803015404.GC11488@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, May 09, 2008 at 07:21:15PM -0700, Christoph Lameter wrote:
>> Support defragmentation for extX filesystem inodes
> 
> You forgot to change "extX" to "ext4".  :-)

Fixed that up now.

>> Reviewed-by: Rik van Riel <riel@redhat.com>
>> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> Acked-by: "Theodore Ts'o" <tytso@mit.edu>

Thanks!
