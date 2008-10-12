Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYJLBHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYJLBHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 21:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYJLBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 21:07:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYJLBH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 21:07:26 -0400
Message-ID: <48F14DAF.8060306@redhat.com>
Date: Sat, 11 Oct 2008 20:06:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
References: <1223525160-9887-36-git-send-email-tytso@mit.edu> <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu> <48F122FC.6040107@goop.org> <48F12427.5090801@redhat.com> <20081011225826.GD12662@mit.edu>
In-Reply-To: <20081011225826.GD12662@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:

> The only other problem may arise on distro's that depend on vol_id for
> mount/fsck, 

And hal (also used volume_id)...

And quota. (has "ext4dev" as a type but no ext4 atm)

-Eric
