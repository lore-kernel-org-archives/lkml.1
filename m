Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYJUHQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYJUHQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYJUHQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:16:34 -0400
Received: from phunq.net ([64.81.85.152]:37773 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750721AbYJUHQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:16:33 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 21 Oct 2008 00:16:23 -0700
User-Agent: KMail/1.9.5
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu>
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810210016.23137.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2008 20:43, Theodore Ts'o wrote:
> The original ext3 hash algorithms assumed that variables of type char
> were signed, as God and K&R intended.

But I didn't.  Sorry about that, it was a dumb oversight.

Regards,

Daniel
