Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZDIAsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZDIAsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbZDIArw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:47:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753682AbZDIArv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:47:51 -0400
Date: Wed, 8 Apr 2009 17:44:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-Id: <20090408174443.79e71503.akpm@linux-foundation.org>
In-Reply-To: <20090409003308.GK16602@bilbo.ozlabs.org>
References: <20090408003921.GA5054@ldl.fc.hp.com>
	<20090408010331.GB10768@sgi.com>
	<20090408054612.GA6744@ldl.fc.hp.com>
	<20090407225457.86f8a458.akpm@linux-foundation.org>
	<20090409003308.GK16602@bilbo.ozlabs.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 10:33:08 +1000 Tony Breeds <tony@bakeyournoodle.com> wrote:

> On Tue, Apr 07, 2009 at 10:54:57PM -0700, Andrew Morton wrote:
> 
> > We would benefit very much from having someone who actually maintains a
> > suite of cross-compilers for kernel developers.
> 
> I build wont say maintain many of the cross compilers used for linux-next.  I
> can place them somehere.

Please do.

Several people have made suggestions but I don't think I've yet seen
anything which is download-and-go.  Many of them appear to be ways of
tricking people into installing distributions which include dselect,
but I'm awake to their little games.

