Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJ2VKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJ2VKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYJ2VKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:10:04 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57925 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752481AbYJ2VKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:10:01 -0400
Date: Wed, 29 Oct 2008 17:09:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Arthur Jones <ajones@riverbed.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       sct@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: ext3: slow symlink corruption on umount...
Message-ID: <20081029210949.GA27274@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Arthur Jones <ajones@riverbed.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	sct@redhat.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4908C951.2000309@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 03:36:33PM -0500, Eric Sandeen wrote:
> 
> Sorry for the silence, this is a nice bug you've found :)
> 
> I'll look into it ...

You may want to take a quick look at this thread:

    http://lkml.org/lkml/2008/10/28/413

					- Ted
