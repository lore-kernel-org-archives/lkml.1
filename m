Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZI1O3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZI1O3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZI1O3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:29:03 -0400
Received: from thunk.org ([69.25.196.29]:38904 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZI1O3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:29:02 -0400
Date: Mon, 28 Sep 2009 10:29:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: wbrana@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4/reiser3/btr directory create/read perf
Message-ID: <20090928142903.GD17514@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, wbrana@gmail.com,
	linux-kernel@vger.kernel.org
References: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 02:27:55PM +0200, wbrana@gmail.com wrote:
> Hello,
> 
> I executed benchmark which creates and reads 10000 directories.
> It is much slower with ext4 than with reiser3 or btrfs.

What precisely is your benchmark doing/measuring?  What are the times
if you enable dir_index?

					- Ted
